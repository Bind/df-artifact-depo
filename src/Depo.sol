// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import {ERC721TokenReceiver, ERC721} from "solmate/tokens/ERC721.sol";
import "./DFCore.sol";

// Todo: Handle depositing same item multiple times

contract Depo is ERC721TokenReceiver {
    address immutable DF_CORE;
    mapping(address => bool) public masters_at_arms; // Can withdraw
    mapping(uint256 => bool) public deposits; // Artifacts currently deposited
    mapping(address => uint256[]) public records; // who deposited what
    modifier onlyMasterAtArms() {
        require(masters_at_arms[msg.sender], "ONLY_MAA");
        _;
    }

    constructor(address dfCore, address[] memory blessed) {
        DF_CORE = dfCore;
        for (uint256 i = 0; i < blessed.length; i++) {
            masters_at_arms[blessed[i]] = true;
        }
    }

    function receipts(address depositor)
        public
        view
        returns (uint256[] memory)
    {
        return records[depositor];
    }

    function promote(address pleb) public onlyMasterAtArms {
        masters_at_arms[pleb] = true;
    }

    function withdrawArtifact(uint256 tokenId) public onlyMasterAtArms {
        require(deposits[tokenId], "TOKEN NOT DEPOSTED");
        DFCore(DF_CORE).safeTransferFrom(address(this), msg.sender, tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        require(msg.sender == DF_CORE, "NOTCORE");
        deposits[tokenId] = true;
        records[from].push(tokenId);
        return this.onERC721Received.selector;
    }
}
