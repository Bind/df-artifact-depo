// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";

import {Depo} from "src/Depo.sol";
import {DFMock} from "src/DFMock.sol";

contract DepoTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    address payable alice;
    address payable bob;
    Utilities internal utils;
    address payable[] internal users;
    address payable[] internal bad_users;
    Depo internal depo;
    DFCore internal dfcore;
    DFCore internal bad_core;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(5);
        alice = users[0];
        bad_users = utils.createUsers(5);
        bob = bad_users[0];
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        dfcore = new DFMock("mock", "DF");
        bad_core = new DFMock("bad", "DF");
        address[] memory _users = new address[](5);
        for (uint256 i = 0; i < users.length; i++) {
            _users[i] = address(users[i]);
        }
        dfcore.createArtifacts(alice, 5);
        bad_core.createArtifacts(alice, 5);
        depo = new Depo(address(dfcore), _users);
    }

    function testDeposit() public {
        // labels alice's address in call traces as "Alice [<address>]"
        vm.prank(alice);
        dfcore.safeTransferFrom(alice, address(depo), 0);
        uint256[] memory recs = depo.receipts(alice);
        assertEq(recs.length, 1);
        bool deposited = depo.deposits(0);
        assert(deposited);
    }

    function testEnemyWithdrawl() public {
        vm.prank(alice);

        // Alice make deposit
        dfcore.safeTransferFrom(alice, address(depo), 0);
        uint256[] memory recs = depo.receipts(alice);
        assertEq(recs.length, 1);
        // Bad user should not be able to withdraw
        vm.prank(bob);
        vm.expectRevert("ONLY_MAA");
        depo.withdrawArtifact(0);
    }

    function testMAAWithdrawl() public {
        vm.prank(alice);
        // Test Deposit flow
        dfcore.safeTransferFrom(alice, address(depo), 0);
        vm.prank(users[1]);
        depo.withdrawArtifact(0);
        // Assert blessed user 1 should be able to withdraw
        assertEq(dfcore.ownerOf(0), users[1]);
        // Assert Alice is still accredited with the initial deposit
        uint256[] memory recs = depo.receipts(alice);
        assertEq(recs.length, 1);
        // Should no longer be able to withdraw
        bool deposited = depo.deposits(0);
        assert(!deposited);
    }

    function testBadBlessedDeposit() public {
        vm.prank(alice);
        // Test Deposit flow from malicious contract
        vm.expectRevert("NOTCORE");
        // Depo should revert on malicious deposit
        bad_core.safeTransferFrom(alice, address(depo), 1);
        // Should have no receipts
        uint256[] memory recs = depo.receipts(alice);
        assertEq(recs.length, 0);
        // Deposit should not be marked true
        assert(!depo.deposits(1));
    }
}
