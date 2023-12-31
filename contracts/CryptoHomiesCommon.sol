// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./CommonERC721.sol";

contract CryptoHomiesCommon is CommonERC721 {
    address public genesisContract;

    uint16 public mintsWithGenesis = 3;
    uint16 public mintLimitPerTransaction = 3;

    constructor(
        address owner,
        string memory _contractURI
    )
        CommonERC721(
            "CryptoHomiesCommon",
            "CHC",
            5994,
            0.1 ether,
            _contractURI
        )
    {
        genesisContract = msg.sender;
        _transferOwnership(owner);
    }

    function mintWithGenesis(address _to) public onlyGenesis returns (bool) {
        for (uint16 i = 0; i < mintsWithGenesis; i++) {
            _mint(_to);
        }

        return true;
    }

    function mintTokensForOwner(uint16 _amount) public onlyOwner {
        require(saleActive, "Sale not active");
        require(_amount <= mintLimitPerTransaction, "Minting limit exceeded");
        require(!mintedUsers[currentStage][owner()], "Owner has minted already");
        require(tokenIdCount + _amount <= MAX_SUPPLY, "No more items left");

        for (uint16 i = 0; i < _amount; i++) {
            _mint(owner());
        }

        mintedUsers[currentStage][owner()] = true;
    }

    function _mint(address _to) internal {
        ++tokenIdCount;
        _safeMint(_to, tokenIdCount);
    }

    modifier onlyGenesis() {
        require(msg.sender == genesisContract || msg.sender == owner(), "Caller is not authorized");
        _;
    }

    function changeMintLimitPerTransaction(uint16 _mintLimitPerTransaction) public onlyOwner {
        mintLimitPerTransaction = _mintLimitPerTransaction;
    }

    function changeMintsWithGenesis(uint16 _mintsWithGenesis) public onlyOwner {
        mintsWithGenesis = _mintsWithGenesis;
    }
}
