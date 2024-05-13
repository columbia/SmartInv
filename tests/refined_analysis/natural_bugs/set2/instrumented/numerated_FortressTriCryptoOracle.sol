1 // // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____         _                   _____     _ _____             _       _____             _     
18 // |   __|___ ___| |_ ___ ___ ___ ___|_   _|___|_|     |___ _ _ ___| |_ ___|     |___ ___ ___| |___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -| | | |  _| |   --|  _| | | . |  _| . |  |  |  _| .'|  _| | -_|
20 // |__|  |___|_| |_| |_| |___|___|___| |_| |_| |_|_____|_| |_  |  _|_| |___|_____|_| |__,|___|_|___|
21 //                                                         |___|_|                                  
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {ITriCryptoLpPriceOracle} from "../interfaces/ITriCryptoLpPriceOracle.sol";
26 
27 import "./BaseOracle.sol";
28 
29 contract FortressTriCryptoOracle is BaseOracle {
30 
31     using SafeCast for uint256;
32 
33     /********************************** Constructor **********************************/
34 
35     constructor(address _owner, address _vault) BaseOracle(_owner, _vault) {}
36 
37     /********************************** External Functions **********************************/
38 
39     function description() external pure override returns (string memory) {
40         return "fcTriCrypto USD Oracle";
41     }
42 
43     /********************************** Internal Functions **********************************/
44 
45     function _getPrice() internal view override returns (int256) {
46         address _triCryptoLpPriceOracle= address(0x2C2FC48c3404a70F2d33290d5820Edf49CBf74a5);
47         uint256 _assetPrice = ITriCryptoLpPriceOracle(_triCryptoLpPriceOracle).lp_price();
48 
49         uint256 _sharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);
50 
51         // check that vault share price deviation did not exceed the configured bounds
52         if (isCheckPriceDeviation) _checkPriceDeviation(_sharePrice);
53         _checkVaultSpread();
54 
55         return _sharePrice.toInt256();
56     }
57 
58     /********************************** Owner Functions **********************************/
59 
60     /// @notice this function needs to be called periodically to update the last share price
61     function updateLastSharePrice() external override onlyOwner {
62         address _triCryptoLpPriceOracle= address(0x2C2FC48c3404a70F2d33290d5820Edf49CBf74a5);
63         lastSharePrice = ((ERC4626(vault).convertToAssets(ITriCryptoLpPriceOracle(_triCryptoLpPriceOracle).lp_price()) * DECIMAL_DIFFERENCE) / BASE);
64 
65         emit LastSharePriceUpdated(lastSharePrice);
66     }
67 }