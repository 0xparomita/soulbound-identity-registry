// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract SoulboundIdentity is ERC721, AccessControl {
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");

    mapping(uint256 => string) private _tokenURIs;

    event AttestationMinted(address indexed to, uint256 indexed tokenId, string uri);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev Mint a new identity token to a user.
     * Only addresses with the ISSUER_ROLE can call this.
     */
    function issueIdentity(address to, uint256 tokenId, string memory uri) external onlyRole(ISSUER_ROLE) {
        _safeMint(to, tokenId);
        _tokenURIs[tokenId] = uri;
        emit AttestationMinted(to, tokenId, uri);
    }

    /**
     * @dev Override the transfer logic to make it Soulbound.
     * Reverts if 'from' and 'to' are both non-zero (i.e., a transfer attempt).
     */
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        
        // Allow minting (from == address(0)) and burning (to == address(0))
        // Revert on any other transfer
        if (from != address(0) && to != address(0)) {
            revert("Soulbound: Transfer not allowed");
        }
        
        return super._update(to, tokenId, auth);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        return _tokenURIs[tokenId];
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
