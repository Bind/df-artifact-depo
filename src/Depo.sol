// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import {ERC721TokenReceiver, ERC721} from "solmate/tokens/ERC721.sol";
import "./DFMock.sol";

contract Depo is ERC721TokenReceiver {
    /*///////////////////////////////////////////////////////////////
                               MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyMasterAtArms() {
        require(mastersAtArms[msg.sender], "ONLY_MAA");
        _;
    }

    /*///////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Deposit(address indexed depositor, uint256 indexed tokenId);

    event Withdrawl(address indexed withdrawer, uint256 indexed tokenId);

    /*///////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    address public immutable dfCore;

    mapping(address => bool) public mastersAtArms; // Can withdraw

    mapping(uint256 => bool) public deposits; // Artifacts currently deposited

    /*///////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address core, address[] memory blessed) {
        dfCore = core;
        for (uint256 i = 0; i < blessed.length; i++) {
            mastersAtArms[blessed[i]] = true;
        }
    }

    /*///////////////////////////////////////////////////////////////
                             ACCESS CONTROL
    //////////////////////////////////////////////////////////////*/

    function promote(address pleb) public onlyMasterAtArms {
        mastersAtArms[pleb] = true;
    }

    /*///////////////////////////////////////////////////////////////
                               DEPO LOGIC
    //////////////////////////////////////////////////////////////*/

    function withdrawArtifact(uint256 tokenId) public onlyMasterAtArms {
        require(deposits[tokenId], "TOKEN NOT DEPOSTED");
        DFMock(dfCore).safeTransferFrom(address(this), msg.sender, tokenId);
        deposits[tokenId] = false;
        emit Withdrawl(msg.sender, tokenId);
    }

    function onERC721Received(
        address,
        address from,
        uint256 tokenId,
        bytes calldata
    ) external returns (bytes4) {
        require(msg.sender == dfCore, "NOTCORE");
        deposits[tokenId] = true;
        emit Deposit(from, tokenId);
        return this.onERC721Received.selector;
    }
}
