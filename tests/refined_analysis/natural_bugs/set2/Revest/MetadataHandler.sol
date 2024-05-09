// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IMetadataHandler.sol";


contract MetadataHandler is Ownable, IMetadataHandler{

    string public uri;
    string public renderURI;

    constructor(string memory _uri) Ownable() {
        uri = _uri;
    }

    function getTokenURI(uint fnftId) external view override returns (string memory ) {
        return uri;
    }

    function setTokenURI(uint fnftId, string memory _uri) external override {
        uri = _uri;
    }

    function getRenderTokenURI(
        uint tokenId,
        address owner
    ) external view override returns (string memory baseRenderURI, string[] memory parameters) {
        string[] memory arr;
        return (renderURI, arr);
    }

    function setRenderTokenURI(
        uint tokenID,
        string memory baseRenderURI
    ) external override {
        renderURI = baseRenderURI;
    }
}
