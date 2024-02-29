// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error NonExistentTokenURI();
error WithdrawTransfer();

contract NFT is ERC721, Ownable {

    using Strings for uint256;
    uint256 public currentTokenId;

    // maps tokenID to tokenURI
    mapping(uint256 => string) internal _tokenURI;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
    }

    function mintTo(address recipient, string memory newTokenURI) public onlyOwner returns (uint256) {
        uint256 newTokenId = ++currentTokenId;

        _safeMint(recipient, newTokenId);

        // todo: emit event for the same
        _tokenURI[newTokenId] = newTokenURI;

        return newTokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (ownerOf(tokenId) == address(0) || tokenId > currentTokenId) {
            revert NonExistentTokenURI();
        }

        return _tokenURI[tokenId];
    }
}
