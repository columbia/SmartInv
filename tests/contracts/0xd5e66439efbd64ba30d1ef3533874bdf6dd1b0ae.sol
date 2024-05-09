// SPDX-License-Identifier: MIT

/*
     .____    .__             .__    .___
     |    |   |__| ________ __|__| __| _/
     |    |   |  |/ ____/  |  \  |/ __ |
     |    |___|  < <_|  |  |  /  / /_/ |
     |_______ \__|\__   |____/|__\____ |
             \/      |__|             \/
 ___________.__  __
 \__    ___/|__|/  |______    ____   ______
   |    |   |  \   __\__  \  /    \ /  ___/
   |    |   |  ||  |  / __ \|   |  \\___ \
   |____|   |__||__| (____  /___|  /____  >
                          \/     \/     \/

We don't need no water, let that motherf*cker burn!
*/

pragma solidity ^0.8.0;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function getApproved(uint256 tokenId) external view returns (address);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC1155 {
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
}

contract TitanItemBurns {
    address public DEAD = 0x000000000000000000000000000000000000dEaD;
    address public Legends = 0x372405A6d95628Ad14518BfE05165D397f43dE1D;
    address public Invaders = 0x2f3A9adc5301600Cd9205eF7657cF0733fF71D04;
    address public Artifacts = 0xf85906f89aecA56aff6D34790677595aF6B4FBD7;
    address public Titans = 0x21d6Fe3B109808Fc69CDaF9829457B0d780Bd975;
    address public LiquidDeployer = 0x866cfDa1B7cD90Cd250485cd8b700211480845D7;

    // NOTE: We could have done this brute-force with a bunch of static fields, but
    //       instead we are doing it with a dynamic set of traits contained in the traits
    //       struct and a mapping into that struct for updates. It's harder and takes
    //       a bit more gas, but doesn't force us into static traits in the future if
    //       we add additional items to the list
    //
    struct TokenBurnContract {
        uint256 maxTokenId;
        string name;
    }
    mapping(address => TokenBurnContract) public TokenBurnContracts;

    struct TitanLevels {
        address contractAddress;
        uint256 tokenId;
    }

    mapping(uint256 => mapping(address => TitanLevels)) public AllTitanLevels;

    constructor() {
        addTokenBurnContract(
            0x656BCe393341ED876c2e429B29B2Ff1C935b3c4B,
            27,
            "Armor"
        );
        addTokenBurnContract(
            0x93c9c0cE57e4Bf051AB81B6A9c683a932A7c8fEc,
            24,
            "Weapon"
        );
        addTokenBurnContract(
            0x0814aB15114D303e9970a3463e0ef170C6A406DE,
            24,
            "Enhancement"
        );
        addTokenBurnContract(
            0xDde7505f40a61032Ed076452f85C0F54DFA208Bd,
            18,
            "Artifact"
        );
    }

    // ------------------------------------------------------------------------
    // Add and remove tokens that can be burned, spindled, folded, & mutilated
    // ------------------------------------------------------------------------
    function addTokenBurnContract(
        address contractAddress,
        uint256 maxTokenId,
        string memory name
    ) public {
        require(
            msg.sender == LiquidDeployer,
            "Only LiquidDeployer can add Token burn contracts"
        );

        TokenBurnContracts[contractAddress] = TokenBurnContract(
            maxTokenId,
            name
        );
    }

    function removeTokenBurnContract(address contractAddress) public {
        require(
            msg.sender == LiquidDeployer,
            "Only LiquidDeployer can remove Token burn contracts"
        );

        delete TokenBurnContracts[contractAddress];
    }

    function updateTokenBurnContract(
        address contractAddress,
        uint256 maxTokenId,
        string memory name
    ) public {
        require(
            msg.sender == LiquidDeployer,
            "Only LiquidDeployer can update Token burn contracts"
        );

        TokenBurnContracts[contractAddress] = TokenBurnContract(
            maxTokenId,
            name
        );
    }

    // -------------------------------------------------------------------------
    // The functions used by the account burning the artifact or nfts for traits
    // -------------------------------------------------------------------------

    function getTitanLevels(
        uint256 key,
        address addr
    ) public view returns (TitanLevels memory) {
        return AllTitanLevels[key][addr];
    }

    event TitanLevelUp(
        address indexed owner,
        uint256 titanId,
        address contractAddress,
        string contractName,
        uint256 tokenId
    );

    // This requires an approval for the contract and token before it will work
    // Go to the original contract and "Approve All" instead of each token id
    // to save gas over the long term
    function updateTitanLevel(
        uint256 titanId,
        address contractAddress,
        uint256 tokenId
    ) public {
        require(
            IERC1155(contractAddress).balanceOf(msg.sender, tokenId) > 0,
            "Only the owner of the token can update the titan level"
        );
        require(
            IERC721(Titans).ownerOf(titanId) == msg.sender,
            "You do not own this Titan!"
        );
        TitanLevels storage titanLevel = AllTitanLevels[titanId][
            contractAddress
        ];
        if (titanLevel.contractAddress == address(0)) {
            titanLevel.contractAddress = contractAddress;
            titanLevel.tokenId = tokenId;
        } else if (tokenId <= titanLevel.tokenId) {
            revert(
                "Token ID must be greater than the current token ID for this titan"
            );
        } else if (tokenId > titanLevel.tokenId + 1) {
            revert(
                "Token ID must be less than or equal to current token ID + 1 for this titan"
            );
        } else {
            titanLevel.tokenId = tokenId;
        }
        IERC1155(contractAddress).safeTransferFrom(
            msg.sender,
            DEAD,
            tokenId,
            1,
            ""
        );
    }

    // This is the end. My only friend, the end [of the contract].
}