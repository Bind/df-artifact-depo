// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import {ERC721} from "solmate/tokens/ERC721.sol";

contract DFMock is ERC721("df", "MOCK") {
    function tokenURI(uint256) public pure override returns (string memory) {
        return "";
    }

    function mint(address to, uint256 tokenId) public virtual {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) public virtual {
        _burn(tokenId);
    }

    function safeMint(address to, uint256 tokenId) public virtual {
        _safeMint(to, tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual {
        _safeMint(to, tokenId, data);
    }

    function createArtifacts(address to, uint8 amount) public {
        for (uint8 i = 0; i < amount; i++) {
            _safeMint(to, uint256(i));
        }
    }
}
