// Sources flattened with buidler v1.4.3 https://buidler.dev

// File @openzeppelin/contracts/GSN/Context.sol@v3.1.0

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v3.1.0

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


// File @openzeppelin/contracts/cryptography/ECDSA.sol@v3.1.0

pragma solidity ^0.6.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}


// File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0

/*
https://github.com/OpenZeppelin/openzeppelin-contracts

The MIT License (MIT)

Copyright (c) 2016-2019 zOS Global Limited

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity 0.6.8;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


// File @animoca/f1dt-ethereum-contracts/contracts/metadata/Crates2020RNGLib.sol@v1.0.0

pragma solidity 0.6.8;

library Crates2020RNGLib {

    struct Metadata {
        uint256 tokenType;
        uint256 tokenSubType;
        uint256 model;
        uint256 team;
        uint256 tokenRarity;
        uint256 label;
        uint256 driver;
        uint256 stat1;
        uint256 stat2;
        uint256 stat3;
        uint256 counter;
    }

    uint256 constant CRATE_TIER_LEGENDARY = 0;
    uint256 constant CRATE_TIER_EPIC = 1;
    uint256 constant CRATE_TIER_RARE = 2;
    uint256 constant CRATE_TIER_COMMON = 3;

    //============================================================================================/
    //================================== Metadata Mappings  ======================================/
    //============================================================================================/

    uint256 internal constant _NF_FLAG = 1 << 255;

    uint256 internal constant _SEASON_ID_2020 = 3;

    uint256 internal constant _TYPE_ID_CAR = 1;
    uint256 internal constant _TYPE_ID_DRIVER = 2;
    uint256 internal constant _TYPE_ID_PART = 3;
    uint256 internal constant _TYPE_ID_GEAR = 4;
    uint256 internal constant _TYPE_ID_TYRES = 5;

    uint256 internal constant _TEAM_ID_ALFA_ROMEO_RACING = 1;
    uint256 internal constant _TEAM_ID_SCUDERIA_FERRARI = 2;
    uint256 internal constant _TEAM_ID_HAAS_F1_TEAM = 3;
    uint256 internal constant _TEAM_ID_MCLAREN_F1_TEAM = 4;
    uint256 internal constant _TEAM_ID_MERCEDES_AMG_PETRONAS_MOTORSPORT = 5;
    uint256 internal constant _TEAM_ID_SPSCORE_RACING_POINT_F1_TEAM = 6;
    uint256 internal constant _TEAM_ID_ASTON_MARTIN_RED_BULL_RACING = 7;
    uint256 internal constant _TEAM_ID_RENAULT_F1_TEAM = 8;
    uint256 internal constant _TEAM_ID_RED_BULL_TORO_ROSSO_HONDA = 9;
    uint256 internal constant _TEAM_ID_ROKIT_WILLIAMS_RACING = 10;

    uint256 internal constant _DRIVER_ID_KIMI_RAIKKONEN = 7;
    uint256 internal constant _DRIVER_ID_ANTONIO_GIOVINAZZI = 99;
    uint256 internal constant _DRIVER_ID_SEBASTIAN_VETTEL = 5;
    uint256 internal constant _DRIVER_ID_CHARLES_LECLERC = 16;
    uint256 internal constant _DRIVER_ID_ROMAIN_GROSJEAN = 8;
    uint256 internal constant _DRIVER_ID_KEVIN_MAGNUSSEN = 20;
    uint256 internal constant _DRIVER_ID_LANDO_NORRIS = 4;
    uint256 internal constant _DRIVER_ID_CARLOS_SAINZ = 55;
    uint256 internal constant _DRIVER_ID_LEWIS_HAMILTON = 44;
    uint256 internal constant _DRIVER_ID_VALTTERI_BOTTAS = 77;
    uint256 internal constant _DRIVER_ID_SERGIO_PEREZ = 11;
    uint256 internal constant _DRIVER_ID_LANCE_STROLL = 18;
    uint256 internal constant _DRIVER_ID_PIERRE_GASLY = 10;
    uint256 internal constant _DRIVER_ID_MAX_VERSTAPPEN = 33;
    uint256 internal constant _DRIVER_ID_DANIEL_RICCIARDO = 3;
    // uint256 internal constant _DRIVER_ID_NICO_HULKENBERG = 27;
    uint256 internal constant _DRIVER_ID_ALEXANDER_ALBON = 23;
    uint256 internal constant _DRIVER_ID_DANIIL_KVYAT = 26;
    uint256 internal constant _DRIVER_ID_GEORGE_RUSSEL = 63;
    // uint256 internal constant _DRIVER_ID_ROBERT_KUBICA = 88;
    uint256 internal constant _DRIVER_ID_ESTEBAN_OCON = 31;
    uint256 internal constant _DRIVER_ID_NICHOLAS_LATIFI = 6;


    //============================================================================================/
    //================================ Racing Stats Min/Max  =====================================/
    //============================================================================================/

    uint256 internal constant _RACING_STATS_T1_RARITY_1_MIN = 800;
    uint256 internal constant _RACING_STATS_T1_RARITY_1_MAX = 900;
    uint256 internal constant _RACING_STATS_T1_RARITY_2_MIN = 710;
    uint256 internal constant _RACING_STATS_T1_RARITY_2_MAX = 810;
    uint256 internal constant _RACING_STATS_T1_RARITY_3_MIN = 680;
    uint256 internal constant _RACING_STATS_T1_RARITY_3_MAX = 780;
    uint256 internal constant _RACING_STATS_T1_RARITY_4_MIN = 610;
    uint256 internal constant _RACING_STATS_T1_RARITY_4_MAX = 710;
    uint256 internal constant _RACING_STATS_T1_RARITY_5_MIN = 570;
    uint256 internal constant _RACING_STATS_T1_RARITY_5_MAX = 680;
    uint256 internal constant _RACING_STATS_T1_RARITY_6_MIN = 540;
    uint256 internal constant _RACING_STATS_T1_RARITY_6_MAX = 650;
    uint256 internal constant _RACING_STATS_T1_RARITY_7_MIN = 500;
    uint256 internal constant _RACING_STATS_T1_RARITY_7_MAX = 580;
    uint256 internal constant _RACING_STATS_T1_RARITY_8_MIN = 480;
    uint256 internal constant _RACING_STATS_T1_RARITY_8_MAX = 550;
    uint256 internal constant _RACING_STATS_T1_RARITY_9_MIN = 450;
    uint256 internal constant _RACING_STATS_T1_RARITY_9_MAX = 540;

    uint256 internal constant _RACING_STATS_T2_RARITY_1_MIN = 500;
    uint256 internal constant _RACING_STATS_T2_RARITY_1_MAX = 600;
    uint256 internal constant _RACING_STATS_T2_RARITY_2_MIN = 420;
    uint256 internal constant _RACING_STATS_T2_RARITY_2_MAX = 520;
    uint256 internal constant _RACING_STATS_T2_RARITY_3_MIN = 380;
    uint256 internal constant _RACING_STATS_T2_RARITY_3_MAX = 480;
    uint256 internal constant _RACING_STATS_T2_RARITY_4_MIN = 340;
    uint256 internal constant _RACING_STATS_T2_RARITY_4_MAX = 440;
    uint256 internal constant _RACING_STATS_T2_RARITY_5_MIN = 330;
    uint256 internal constant _RACING_STATS_T2_RARITY_5_MAX = 430;
    uint256 internal constant _RACING_STATS_T2_RARITY_6_MIN = 290;
    uint256 internal constant _RACING_STATS_T2_RARITY_6_MAX = 390;
    uint256 internal constant _RACING_STATS_T2_RARITY_7_MIN = 250;
    uint256 internal constant _RACING_STATS_T2_RARITY_7_MAX = 350;
    uint256 internal constant _RACING_STATS_T2_RARITY_8_MIN = 240;
    uint256 internal constant _RACING_STATS_T2_RARITY_8_MAX = 340;
    uint256 internal constant _RACING_STATS_T2_RARITY_9_MIN = 200;
    uint256 internal constant _RACING_STATS_T2_RARITY_9_MAX = 300;

    uint256 internal constant _RACING_STATS_T3_RARITY_1_MIN = 500;
    uint256 internal constant _RACING_STATS_T3_RARITY_1_MAX = 600;
    uint256 internal constant _RACING_STATS_T3_RARITY_2_MIN = 420;
    uint256 internal constant _RACING_STATS_T3_RARITY_2_MAX = 520;
    uint256 internal constant _RACING_STATS_T3_RARITY_3_MIN = 380;
    uint256 internal constant _RACING_STATS_T3_RARITY_3_MAX = 480;
    uint256 internal constant _RACING_STATS_T3_RARITY_4_MIN = 340;
    uint256 internal constant _RACING_STATS_T3_RARITY_4_MAX = 440;
    uint256 internal constant _RACING_STATS_T3_RARITY_5_MIN = 330;
    uint256 internal constant _RACING_STATS_T3_RARITY_5_MAX = 430;
    uint256 internal constant _RACING_STATS_T3_RARITY_6_MIN = 290;
    uint256 internal constant _RACING_STATS_T3_RARITY_6_MAX = 390;
    uint256 internal constant _RACING_STATS_T3_RARITY_7_MIN = 250;
    uint256 internal constant _RACING_STATS_T3_RARITY_7_MAX = 350;
    uint256 internal constant _RACING_STATS_T3_RARITY_8_MIN = 240;
    uint256 internal constant _RACING_STATS_T3_RARITY_8_MAX = 340;
    uint256 internal constant _RACING_STATS_T3_RARITY_9_MIN = 200;
    uint256 internal constant _RACING_STATS_T3_RARITY_9_MAX = 300;

    //============================================================================================/
    //================================== Types Drop Rates  =======================================/
    //============================================================================================/

    uint256 internal constant _TYPE_DROP_RATE_THRESH_COMPONENT = 82500;

    //============================================================================================/
    //================================== Rarity Drop Rates  ======================================/
    //============================================================================================/

    uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_COMMON = 98.899 * 1000;
    uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_RARE = 1 * 1000 + _COMMON_CRATE_DROP_RATE_THRESH_COMMON;
    uint256 internal constant _COMMON_CRATE_DROP_RATE_THRESH_EPIC = 0.1 * 1000 + _COMMON_CRATE_DROP_RATE_THRESH_RARE;

    uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_COMMON = 96.490 * 1000;
    uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_RARE = 2.5 * 1000 + _RARE_CRATE_DROP_RATE_THRESH_COMMON;
    uint256 internal constant _RARE_CRATE_DROP_RATE_THRESH_EPIC = 1 * 1000 + _RARE_CRATE_DROP_RATE_THRESH_RARE;

    uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_COMMON = 92.4 * 1000;
    uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_RARE = 5 * 1000 + _EPIC_CRATE_DROP_RATE_THRESH_COMMON;
    uint256 internal constant _EPIC_CRATE_DROP_RATE_THRESH_EPIC = 2.5 * 1000 + _EPIC_CRATE_DROP_RATE_THRESH_RARE;

    uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON = 84 * 1000;
    uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE = 10 * 1000 + _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON;
    uint256 internal constant _LEGENDARY_CRATE_DROP_RATE_THRESH_EPIC = 5 * 1000 + _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE;

    // Uses crateSeed bits [0;10[
    function generateCrate(uint256 crateSeed, uint256 crateTier, uint256 counter) internal pure returns (uint256[] memory tokens) {
        tokens = new uint256[](5);
        if (crateTier == CRATE_TIER_COMMON) {
            uint256 guaranteedRareDropIndex = crateSeed % 5;

            for (uint256 i = 0; i != 5; ++i) {
                uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
                tokens[i] = _makeTokenId(
                    _generateMetadata(
                        tokenSeed,
                        crateTier,
                        counter,
                        i,
                        i == guaranteedRareDropIndex? CRATE_TIER_RARE: CRATE_TIER_COMMON
                    )
                );
            }
        } else if (crateTier == CRATE_TIER_RARE) {
            (
                uint256 guaranteedRareDropIndex1,
                uint256 guaranteedRareDropIndex2,
                uint256 guaranteedRareDropIndex3
            ) = _generateThreeTokenIndices(crateSeed);

            for (uint256 i = 0; i != 5; ++i) {
                uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
                tokens[i] = _makeTokenId(
                    _generateMetadata(
                        tokenSeed,
                        crateTier,
                        counter,
                        i,
                        (
                            i == guaranteedRareDropIndex1 ||
                            i == guaranteedRareDropIndex2 ||
                            i == guaranteedRareDropIndex3
                        ) ? CRATE_TIER_RARE: CRATE_TIER_COMMON
                    )
                );
            }
        } else if (crateTier == CRATE_TIER_EPIC) {
            (
                uint256 guaranteedRareDropIndex,
                uint256 guaranteedEpicDropIndex
            ) = _generateTwoTokenIndices(crateSeed);

            for (uint256 i = 0; i != 5; ++i) {
                uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
                uint256 minRarityTier = CRATE_TIER_COMMON;
                if (i == guaranteedRareDropIndex) {
                    minRarityTier = CRATE_TIER_RARE;
                } else if (i == guaranteedEpicDropIndex) {
                    minRarityTier = CRATE_TIER_EPIC;
                }
                tokens[i] = _makeTokenId(
                    _generateMetadata(
                        tokenSeed,
                        crateTier,
                        counter,
                        i,
                        minRarityTier
                    )
                );
            }
        } else if (crateTier == CRATE_TIER_LEGENDARY) {
            (
                uint256 guaranteedRareDropIndex,
                uint256 guaranteedLegendaryDropIndex
            ) = _generateTwoTokenIndices(crateSeed);

            for (uint256 i = 0; i != 5; ++i) {
                uint256 tokenSeed = uint256(keccak256(abi.encodePacked(crateSeed, i)));
                uint256 minRarityTier = CRATE_TIER_COMMON;
                if (i == guaranteedRareDropIndex) {
                    minRarityTier = CRATE_TIER_RARE;
                } else if (i == guaranteedLegendaryDropIndex) {
                    minRarityTier = CRATE_TIER_LEGENDARY;
                }
                tokens[i] = _makeTokenId(
                    _generateMetadata(
                        tokenSeed,
                        crateTier,
                        counter,
                        i,
                        minRarityTier
                    )
                );
            }
        } else {
            revert("Crates2020RNG: wrong crate tier");
        }
    }

    /**
     * Select one index, then another
    */ 
    function _generateTwoTokenIndices(uint256 crateSeed) internal pure returns (uint256, uint256) {
        uint256 firstIndex = crateSeed % 5;
        return(
            firstIndex,
            (firstIndex + 1 + ((crateSeed >> 4) % 4)) % 5
        );
    }

    /**
     * To generate 3 random indices in a 5-size array, there are 10 possibilities:
     * value  ->  positions  ->  indices
     *   0        O O X X X     (2, 3, 4)
     *   1        O X O X X     (1, 3, 4)
     *   2        O X X O X     (1, 2, 4)
     *   3        O X X X O     (1, 2, 3)
     *   4        X O O X X     (0, 3, 4)
     *   5        X O X O X     (0, 2, 4)
     *   6        X O X X O     (0, 2, 3)
     *   7        X X O O X     (0, 1, 4)
     *   8        X X O X O     (0, 1, 3)
     *   9        X X X O O     (0, 1, 2)
     */
    function _generateThreeTokenIndices(uint256 crateSeed) internal pure returns (uint256, uint256, uint256) {
        uint256 value = crateSeed % 10;
        if (value == 0) return (2, 3, 4);
        if (value == 1) return (1, 3, 4);
        if (value == 2) return (1, 2, 4);
        if (value == 3) return (1, 2, 3);
        if (value == 4) return (0, 3, 4);
        if (value == 5) return (0, 2, 4);
        if (value == 6) return (0, 2, 3);
        if (value == 7) return (0, 1, 4);
        if (value == 8) return (0, 1, 3);
        if (value == 9) return (0, 1, 2);
    }

    function _generateMetadata(
        uint256 tokenSeed,
        uint256 crateTier,
        uint256 counter,
        uint256 index,
        uint256 minRarityTier
    ) private pure returns (Metadata memory metadata) {
        (uint256 tokenType, uint256 tokenSubType) = _generateType(tokenSeed >> 4, index); // Uses tokenSeed bits [4;41[
        metadata.tokenType = tokenType;
        if (tokenSubType != 0) {
            metadata.tokenSubType = tokenSubType;
        }

        uint256 tokenRarity = _generateRarity(tokenSeed >> 41, crateTier, minRarityTier); // Uses tokenSeed bits [41;73[
        metadata.tokenRarity = tokenRarity;

        if (tokenType == _TYPE_ID_CAR || tokenType == _TYPE_ID_DRIVER) {
            if (tokenRarity > 3) {
                metadata.model = _generateModel(tokenSeed >> 73); // Uses tokenSeed bits [73;81[
            } else {
                uint256 team = _generateTeam(tokenSeed >> 73); // Uses tokenSeed bits [73;81[
                metadata.team = team;
                if (tokenType == _TYPE_ID_DRIVER) {
                    metadata.driver = _generateDriver(tokenSeed >> 81, team); // Uses tokenSeed bits [81;82[;
                }
            }
        }

        (metadata.stat1, metadata.stat2, metadata.stat3) = _generateRacingStats(
            tokenSeed >> 128,
            tokenType,
            tokenRarity
        ); // Uses tokenSeed bits [128;170[
        metadata.counter = counter + index;
    }

    function _generateType(uint256 seed, uint256 index)
        private
        pure
        returns (uint256 tokenType, uint256 tokenSubType)
    {
        if (index == 0) {
            tokenType = 1 + (seed % 2); // Types {1, 2} = {Car, Driver}, using 1 bit
            tokenSubType = 0;
        } else {
            uint256 seedling = seed % 100000; // using > 16 bits, reserve 32
            if (seedling < _TYPE_DROP_RATE_THRESH_COMPONENT) {
                uint256 componentTypeSeed = (seed >> 32) % 3; // Type {3, 4} = {Gear, Part}, using 2 bits
                if (componentTypeSeed == 1) { // 1 chance out of 3
                    tokenType = _TYPE_ID_GEAR;
                    tokenSubType = 1 + ((seed >> 34) % 4); // Subtype [1-4], using 2 bits
                } else { // 2 chances out of 3
                    tokenType = _TYPE_ID_PART;
                    tokenSubType = 1 + ((seed >> 34) % 8); // Subtype [1-8], using 3 bits
                }
            } else {
                tokenType = _TYPE_ID_TYRES;
                tokenSubType = 1 + ((seed >> 32) % 5); // Subtype [1-5], using 3 bits
            }
        }
    }

    function _generateRarity(
        uint256 seed,
        uint256 crateTier,
        uint256 minRarityTier
    ) private pure returns (uint256 tokenRarity) {
        uint256 seedling = seed % 100000; // > 16 bits, reserve 32

        if (crateTier == CRATE_TIER_COMMON) {
            if (minRarityTier == CRATE_TIER_COMMON && seedling < _COMMON_CRATE_DROP_RATE_THRESH_COMMON) {
                return 7 + (seedling % 3); // Rarity [7-9]
            }
            if (seedling < _COMMON_CRATE_DROP_RATE_THRESH_RARE) {
                return 4 + (seedling % 3); // Rarity [4-6]
            }
            if (seedling < _COMMON_CRATE_DROP_RATE_THRESH_EPIC) {
                return 2 + (seedling % 2); // Rarity [2-3]
            }
            return 1;
        }

        if (crateTier == CRATE_TIER_RARE) {
            if (minRarityTier == CRATE_TIER_COMMON && seedling < _RARE_CRATE_DROP_RATE_THRESH_COMMON) {
                return 7 + (seedling % 3); // Rarity [7-9]
            }
            if (seedling < _RARE_CRATE_DROP_RATE_THRESH_RARE) {
                return 4 + (seedling % 3); // Rarity [4-6]
            }
            if (seedling < _RARE_CRATE_DROP_RATE_THRESH_EPIC) {
                return 2 + (seedling % 2); // Rarity [2-3]
            }
            return 1;
        }

        if (crateTier == CRATE_TIER_EPIC) {
            if (minRarityTier == CRATE_TIER_COMMON && seedling < _EPIC_CRATE_DROP_RATE_THRESH_COMMON) {
                return 7 + (seedling % 3); // Rarity [7-9]
            }
            if (
                (minRarityTier == CRATE_TIER_COMMON || minRarityTier == CRATE_TIER_RARE)
                && seedling < _EPIC_CRATE_DROP_RATE_THRESH_RARE
            ) {
                return 4 + (seedling % 3); // Rarity [4-6]
            }
            if (seedling < _EPIC_CRATE_DROP_RATE_THRESH_EPIC) {
                return 2 + (seedling % 2); // Rarity [2-3]
            }
            return 1;
        }

        if (crateTier == CRATE_TIER_LEGENDARY) {
            if (minRarityTier == CRATE_TIER_COMMON && seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_COMMON) {
                return 7 + (seedling % 3); // Rarity [7-9]
            }
            if (minRarityTier == CRATE_TIER_COMMON || minRarityTier == CRATE_TIER_RARE) {
                if (seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_RARE) {
                    return 4 + (seedling % 3); // Rarity [4-6]
                }
                if (seedling < _LEGENDARY_CRATE_DROP_RATE_THRESH_EPIC) {
                    return 2 + (seedling % 2); // Rarity [2-3]
                }
            }
            return 1;
        }
    }

    function _generateModel(uint256 seed) private pure returns (uint256 model) {
        model = 1 + (seed % 10);
    }

    function _generateTeam(uint256 seed) private pure returns (uint256 team) {
        team = 1 + (seed % 10);
    }

    function _generateDriver(uint256 seed, uint256 team) private pure returns (uint256 driver) {
        uint256 index = (seed) % 2;

        if (team == _TEAM_ID_ALFA_ROMEO_RACING) {
            driver = [
                _DRIVER_ID_KIMI_RAIKKONEN,
                _DRIVER_ID_ANTONIO_GIOVINAZZI
            ][index];
        } else if (team == _TEAM_ID_SCUDERIA_FERRARI) {
            driver = [
                _DRIVER_ID_SEBASTIAN_VETTEL,
                _DRIVER_ID_CHARLES_LECLERC
            ][index];
        } else if (team == _TEAM_ID_HAAS_F1_TEAM) {
            driver = [
                _DRIVER_ID_ROMAIN_GROSJEAN,
                _DRIVER_ID_KEVIN_MAGNUSSEN
            ][index];
        } else if (team == _TEAM_ID_MCLAREN_F1_TEAM) {
            driver = [
                _DRIVER_ID_LANDO_NORRIS,
                _DRIVER_ID_CARLOS_SAINZ
            ][index];
        } else if (team == _TEAM_ID_MERCEDES_AMG_PETRONAS_MOTORSPORT) {
            driver = [
                _DRIVER_ID_LEWIS_HAMILTON,
                _DRIVER_ID_VALTTERI_BOTTAS
            ][index];
        } else if (team == _TEAM_ID_SPSCORE_RACING_POINT_F1_TEAM) {
            driver = [
                _DRIVER_ID_SERGIO_PEREZ,
                _DRIVER_ID_LANCE_STROLL
            ][index];
        } else if (team == _TEAM_ID_ASTON_MARTIN_RED_BULL_RACING) {
            driver = [
                _DRIVER_ID_ALEXANDER_ALBON,
                _DRIVER_ID_MAX_VERSTAPPEN
            ][index];
        } else if (team == _TEAM_ID_RENAULT_F1_TEAM) {
            driver = [
                _DRIVER_ID_DANIEL_RICCIARDO,
                _DRIVER_ID_ESTEBAN_OCON
            ][index];
        } else if (team == _TEAM_ID_RED_BULL_TORO_ROSSO_HONDA) {
            driver = [
                _DRIVER_ID_PIERRE_GASLY,
                _DRIVER_ID_DANIIL_KVYAT
            ][index];
        } else if (team == _TEAM_ID_ROKIT_WILLIAMS_RACING) {
            driver = [
                _DRIVER_ID_GEORGE_RUSSEL,
                _DRIVER_ID_NICHOLAS_LATIFI
            ][index];
        }
    }

    function _generateRacingStats(
        uint256 seed,
        uint256 tokenType,
        uint256 tokenRarity
    )
        private
        pure
        returns (
            uint256 stat1,
            uint256 stat2,
            uint256 stat3
        )
    {
        uint256 min;
        uint256 max;
        if (tokenType == _TYPE_ID_CAR || tokenType == _TYPE_ID_DRIVER) {
            if (tokenRarity == 1) {
                (min, max) = (_RACING_STATS_T1_RARITY_1_MIN, _RACING_STATS_T1_RARITY_1_MAX);
            } else if (tokenRarity == 2) {
                (min, max) = (_RACING_STATS_T1_RARITY_2_MIN, _RACING_STATS_T1_RARITY_2_MAX);
            } else if (tokenRarity == 3) {
                (min, max) = (_RACING_STATS_T1_RARITY_3_MIN, _RACING_STATS_T1_RARITY_3_MAX);
            } else if (tokenRarity == 4) {
                (min, max) = (_RACING_STATS_T1_RARITY_4_MIN, _RACING_STATS_T1_RARITY_4_MAX);
            } else if (tokenRarity == 5) {
                (min, max) = (_RACING_STATS_T1_RARITY_5_MIN, _RACING_STATS_T1_RARITY_5_MAX);
            } else if (tokenRarity == 6) {
                (min, max) = (_RACING_STATS_T1_RARITY_6_MIN, _RACING_STATS_T1_RARITY_6_MAX);
            } else if (tokenRarity == 7) {
                (min, max) = (_RACING_STATS_T1_RARITY_7_MIN, _RACING_STATS_T1_RARITY_7_MAX);
            } else if (tokenRarity == 8) {
                (min, max) = (_RACING_STATS_T1_RARITY_8_MIN, _RACING_STATS_T1_RARITY_8_MAX);
            } else if (tokenRarity == 9) {
                (min, max) = (_RACING_STATS_T1_RARITY_9_MIN, _RACING_STATS_T1_RARITY_9_MAX);
            } else {
                revert("Wrong token rarity");
            }
        } else if (tokenType == _TYPE_ID_GEAR || tokenType == _TYPE_ID_PART) {
            if (tokenRarity == 1) {
                (min, max) = (_RACING_STATS_T2_RARITY_1_MIN, _RACING_STATS_T2_RARITY_1_MAX);
            } else if (tokenRarity == 2) {
                (min, max) = (_RACING_STATS_T2_RARITY_2_MIN, _RACING_STATS_T2_RARITY_2_MAX);
            } else if (tokenRarity == 3) {
                (min, max) = (_RACING_STATS_T2_RARITY_3_MIN, _RACING_STATS_T2_RARITY_3_MAX);
            } else if (tokenRarity == 4) {
                (min, max) = (_RACING_STATS_T2_RARITY_4_MIN, _RACING_STATS_T2_RARITY_4_MAX);
            } else if (tokenRarity == 5) {
                (min, max) = (_RACING_STATS_T2_RARITY_5_MIN, _RACING_STATS_T2_RARITY_5_MAX);
            } else if (tokenRarity == 6) {
                (min, max) = (_RACING_STATS_T2_RARITY_6_MIN, _RACING_STATS_T2_RARITY_6_MAX);
            } else if (tokenRarity == 7) {
                (min, max) = (_RACING_STATS_T2_RARITY_7_MIN, _RACING_STATS_T2_RARITY_7_MAX);
            } else if (tokenRarity == 8) {
                (min, max) = (_RACING_STATS_T2_RARITY_8_MIN, _RACING_STATS_T2_RARITY_8_MAX);
            } else if (tokenRarity == 9) {
                (min, max) = (_RACING_STATS_T2_RARITY_9_MIN, _RACING_STATS_T2_RARITY_9_MAX);
            } else {
                revert("Wrong token rarity");
            }
        } else if (tokenType == _TYPE_ID_TYRES) {
            if (tokenRarity == 1) {
                (min, max) = (_RACING_STATS_T3_RARITY_1_MIN, _RACING_STATS_T3_RARITY_1_MAX);
            } else if (tokenRarity == 2) {
                (min, max) = (_RACING_STATS_T3_RARITY_2_MIN, _RACING_STATS_T3_RARITY_2_MAX);
            } else if (tokenRarity == 3) {
                (min, max) = (_RACING_STATS_T3_RARITY_3_MIN, _RACING_STATS_T3_RARITY_3_MAX);
            } else if (tokenRarity == 4) {
                (min, max) = (_RACING_STATS_T3_RARITY_4_MIN, _RACING_STATS_T3_RARITY_4_MAX);
            } else if (tokenRarity == 5) {
                (min, max) = (_RACING_STATS_T3_RARITY_5_MIN, _RACING_STATS_T3_RARITY_5_MAX);
            } else if (tokenRarity == 6) {
                (min, max) = (_RACING_STATS_T3_RARITY_6_MIN, _RACING_STATS_T3_RARITY_6_MAX);
            } else if (tokenRarity == 7) {
                (min, max) = (_RACING_STATS_T3_RARITY_7_MIN, _RACING_STATS_T3_RARITY_7_MAX);
            } else if (tokenRarity == 8) {
                (min, max) = (_RACING_STATS_T3_RARITY_8_MIN, _RACING_STATS_T3_RARITY_8_MAX);
            } else if (tokenRarity == 9) {
                (min, max) = (_RACING_STATS_T3_RARITY_9_MIN, _RACING_STATS_T3_RARITY_9_MAX);
            } else {
                revert("Wrong token rarity");
            }
        } else {
            revert("Wrong token type");
        }
        uint256 delta = max - min;
        stat1 = min + (seed % delta);
        stat2 = min + ((seed >> 16) % delta);
        stat3 = min + ((seed >> 32) % delta);
    }

    function _makeTokenId(Metadata memory metadata) private pure returns (uint256 tokenId) {
        tokenId = _NF_FLAG;
        tokenId |= (metadata.tokenType << 240);
        tokenId |= (metadata.tokenSubType << 232);
        tokenId |= (_SEASON_ID_2020 << 224);
        tokenId |= (metadata.model << 192);
        tokenId |= (metadata.team << 184);
        tokenId |= (metadata.tokenRarity << 176);
        tokenId |= (metadata.label << 152);
        tokenId |= (metadata.driver << 136);
        tokenId |= (metadata.stat1 << 120);
        tokenId |= (metadata.stat2 << 104);
        tokenId |= (metadata.stat3 << 88);
        tokenId |= metadata.counter;
    }
}


// File @animoca/f1dt-ethereum-contracts/contracts/game/Crates2020.sol@v1.0.0

pragma solidity ^0.6.8;



interface IF1DTBurnableCrateKey {
    /**
     * Destroys `amount` of token.
     * @dev Reverts if called by any other than the contract owner.
     * @dev Reverts is `amount` is zero.
     * @param amount Amount of token to burn.
     */
    function burn(uint256 amount) external;

    /**
     * See {IERC20-transferFrom(address,address,uint256)}.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external;
}

interface IF1DTInventory {
    /**
     * @dev Public function to mint a batch of new tokens
     * Reverts if some the given token IDs already exist
     * @param to address[] List of addresses that will own the minted tokens
     * @param ids uint256[] List of ids of the tokens to be minted
     * @param uris bytes32[] Concatenated metadata URIs of nfts to be minted
     * @param values uint256[] List of quantities of ft to be minted
     */
    function batchMint(address[] calldata to, uint256[] calldata ids, bytes32[] calldata uris, uint256[] calldata values, bool safe) external;
}

contract Crates2020 is Ownable {
    using Crates2020RNGLib for uint256;

    IF1DTInventory immutable public INVENTORY;
    IF1DTBurnableCrateKey immutable public CRATE_KEY_COMMON;
    IF1DTBurnableCrateKey immutable public CRATE_KEY_RARE;
    IF1DTBurnableCrateKey immutable public CRATE_KEY_EPIC;
    IF1DTBurnableCrateKey immutable public CRATE_KEY_LEGENDARY;

    uint256 public counter;

    constructor(
        IF1DTInventory INVENTORY_,
        IF1DTBurnableCrateKey CRATE_KEY_COMMON_,
        IF1DTBurnableCrateKey CRATE_KEY_RARE_,
        IF1DTBurnableCrateKey CRATE_KEY_EPIC_,
        IF1DTBurnableCrateKey CRATE_KEY_LEGENDARY_,
        uint256 counter_
    ) public {
        require(
            address(INVENTORY_) != address(0) &&
            address(CRATE_KEY_COMMON_) != address(0) &&
            address(CRATE_KEY_EPIC_) != address(0) &&
            address(CRATE_KEY_LEGENDARY_) != address(0),
            "Crates: zero address"
        );
        INVENTORY = INVENTORY_;
        CRATE_KEY_COMMON = CRATE_KEY_COMMON_;
        CRATE_KEY_RARE = CRATE_KEY_RARE_;
        CRATE_KEY_EPIC = CRATE_KEY_EPIC_;
        CRATE_KEY_LEGENDARY = CRATE_KEY_LEGENDARY_;
        counter = counter_;
    }

    function transferCrateKeyOwnership(uint256 crateTier, address newOwner) external onlyOwner {
        IF1DTBurnableCrateKey crateKey = _getCrateKey(crateTier);
        crateKey.transferOwnership(newOwner);
    }

    /**
     * Burn some keys in order to mint 2020 season crates.
     * @dev Reverts if `quantity` is zero.
     * @dev Reverts if `crateTier` is not supported.
     * @dev Reverts if the transfer of the crate key to this contract fails (missing approval or insufficient balance).
     * @dev Reverts if this contract is not owner of the `crateTier`-related contract.
     * @dev Reverts if this contract is not minter of the DeltaTimeInventory contract.
     * @param crateTier The tier identifier for the crates to open.
     * @param quantity The number of crates to open.
     * @param seed The seed used for the metadata RNG.
     */
    function _openCrates(uint256 crateTier, uint256 quantity, uint256 seed) internal {
        require(quantity != 0, "Crates: zero quantity");
        IF1DTBurnableCrateKey crateKey = _getCrateKey(crateTier);

        address sender = _msgSender();
        uint256 amount = quantity * 1000000000000000000;

        crateKey.transferFrom(sender, address(this), amount);
        crateKey.burn(amount);

        bytes32[] memory uris = new bytes32[](5);
        uint256[] memory values = new uint256[](5);
        address[] memory to = new address[](5);
        for (uint256 i; i != 5; ++i) {
            values[i] = 1;
            to[i] = sender;
        }

        uint256 counter_ = counter;
        for (uint256 i; i != quantity; ++i) {
            if (i != 0) {
                seed = uint256(keccak256(abi.encode(seed)));
            }
            uint256[] memory tokens = seed.generateCrate(crateTier, counter_);
            INVENTORY.batchMint(to, tokens, uris, values, false);
            counter_ += 5;
        }
        counter = counter_;
    }

    function _getCrateKey(uint256 crateTier) view internal returns (IF1DTBurnableCrateKey) {
        if (crateTier == Crates2020RNGLib.CRATE_TIER_COMMON) {
            return CRATE_KEY_COMMON;
        } else if (crateTier == Crates2020RNGLib.CRATE_TIER_RARE) {
            return CRATE_KEY_RARE;
        } else if (crateTier == Crates2020RNGLib.CRATE_TIER_EPIC) {
            return CRATE_KEY_EPIC;
        } else if (crateTier == Crates2020RNGLib.CRATE_TIER_LEGENDARY) {
            return CRATE_KEY_LEGENDARY;
        } else {
            revert("Crates: wrong crate tier");
        }
    }
}


// File @animoca/f1dt-ethereum-contracts/contracts/game/Crates2020Locksmith.sol@v1.0.0

pragma solidity ^0.6.8;





contract Crates2020Locksmith is Crates2020 {
    using ECDSA for bytes32;

    // account => crateTier => nonce
    mapping(address => mapping(uint256 => uint256)) public nonces;

    address public signerKey;

    constructor(
        IF1DTInventory INVENTORY_,
        IF1DTBurnableCrateKey COMMON_CRATE_,
        IF1DTBurnableCrateKey RARE_CRATE_,
        IF1DTBurnableCrateKey EPIC_CRATE_,
        IF1DTBurnableCrateKey LEGENDARY_CRATE_,
        uint256 counter_
    ) public Crates2020(INVENTORY_, COMMON_CRATE_, RARE_CRATE_, EPIC_CRATE_, LEGENDARY_CRATE_, counter_) {}

    function setSignerKey(address signerKey_) external onlyOwner {
        signerKey = signerKey_;
    }

    /**
     * Burn some keys in order to mint 2020 season crates.
     * @dev reverts if `crateTier` is not supported.
     * @dev reverts if `quantity` is zero or more than 5.
     * @dev reverts if `signerKey` has not been set.
     * @dev reverts if `sig` is not verified to be a signature as described below.
     * @dev Reverts if the transfer of the crate key to this contract fails (missing approval or insufficient balance).
     * @dev Reverts if this contract is not owner of the `crateTier`-related contract.
     * @dev Reverts if this contract is not minter of the DeltaTimeInventory contract.
     * @param crateTier The tier identifier for the crates to open.
     * @param quantity The number of keys to burn / crates to open.
     * @param sig The signature for keccak256(abi.encode(sender, crateTier, nonce))
     *  signed by the private key paired to the public key `signerKey`, where:
     *  - `sender` is the msg.sender,
     *  - `crateTier` is the tier of crate to open,
     *  - `nonce` is the currently tracked nonce, accessed via `nonces(sender, crateTier)`.
     */
    function insertKeys(uint256 crateTier, uint256 quantity, bytes calldata sig) external {
        require(crateTier <= Crates2020RNGLib.CRATE_TIER_COMMON, "Locksmith: wrong crate tier");
        require(quantity <= 5, "Locksmith: above max quantity");

        address signerKey_ = signerKey;
        require(signerKey_ != address(0), "Locksmith: signer key not set");

        address sender = _msgSender();
        uint256 nonce = nonces[sender][crateTier];
        bytes32 hash_ = keccak256(abi.encode(sender, crateTier, nonce));
        require(hash_.toEthSignedMessageHash().recover(sig) == signerKey_, "Locksmith: invalid signature");

        uint256 seed = uint256(keccak256(sig));
        _openCrates(crateTier, quantity, seed);

        nonces[sender][crateTier] = nonce + 1;
    }
}