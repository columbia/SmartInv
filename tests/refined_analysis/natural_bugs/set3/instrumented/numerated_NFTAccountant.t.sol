1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "forge-std/Test.sol";
5 
6 import {NFTAccountant} from "../accountants/NFTAccountant.sol";
7 import {AccountantTest} from "./utils/AccountantTest.sol";
8 
9 contract NFTAccountantTest is AccountantTest {
10     event ProcessFailure(
11         uint256 indexed id,
12         address indexed user,
13         address indexed recipient,
14         uint256 amount
15     );
16 
17     function test_affectedAssets() public {
18         address payable[14] memory affectedAssets = [
19             0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
20             0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
21             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
22             0x853d955aCEf822Db058eb8505911ED77F175b99e,
23             0xdAC17F958D2ee523a2206206994597C13D831ec7,
24             0x6B175474E89094C44Da98b954EedeAC495271d0F,
25             0xD417144312DbF50465b1C641d016962017Ef6240,
26             0x3d6F0DEa3AC3C607B3998e6Ce14b6350721752d9,
27             0x40EB746DEE876aC1E78697b7Ca85142D178A1Fc8,
28             0xf1a91C7d44768070F711c68f33A7CA25c8D30268,
29             0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0,
30             0x3431F91b3a388115F00C5Ba9FdB899851D005Fb5,
31             0xE5097D9baeAFB89f9bcB78C9290d545dB5f9e9CB,
32             0xf1Dc500FdE233A4055e25e5BbF516372BC4F6871
33         ];
34         for (uint256 i; i < 14; i++) {
35             assertEq(accountant.affectedAssets()[i], affectedAssets[i]);
36         }
37     }
38 
39     function test_isAffectedAsset() public {
40         address payable[14] memory affectedAssets = [
41             0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
42             0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
43             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
44             0x853d955aCEf822Db058eb8505911ED77F175b99e,
45             0xdAC17F958D2ee523a2206206994597C13D831ec7,
46             0x6B175474E89094C44Da98b954EedeAC495271d0F,
47             0xD417144312DbF50465b1C641d016962017Ef6240,
48             0x3d6F0DEa3AC3C607B3998e6Ce14b6350721752d9,
49             0x40EB746DEE876aC1E78697b7Ca85142D178A1Fc8,
50             0xf1a91C7d44768070F711c68f33A7CA25c8D30268,
51             0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0,
52             0x3431F91b3a388115F00C5Ba9FdB899851D005Fb5,
53             0xE5097D9baeAFB89f9bcB78C9290d545dB5f9e9CB,
54             0xf1Dc500FdE233A4055e25e5BbF516372BC4F6871
55         ];
56         for (uint256 i; i < 14; i++) {
57             assertEq(accountant.isAffectedAsset(affectedAssets[i]), true);
58         }
59     }
60 
61     function test_recordOnlyBridgeRouter() public {
62         address _user = defaultUser;
63         address _asset = address(mockToken);
64         uint256 _amount = 1000;
65         vm.expectRevert("only BridgeRouter");
66         vm.prank(address(0xBEEF));
67         accountant.record(_asset, _user, _amount);
68         // second one is executed with msg.sender = address(this)
69         // which is the BridgeRouter
70         accountant.record(_asset, _user, _amount);
71     }
72 
73     function test_initValues() public {
74         // check initialized values once instead of for every test
75         assertEq(accountant.owner(), address(this));
76         assertEq(accountant.bridgeRouter(), address(this));
77         assertEq(accountant.nextID(), 0);
78         assertEq(accountant.totalMinted(defaultAsset), 0);
79         (
80             address _asset,
81             uint96 _amount,
82             address _originalUser,
83             uint96 _recovered
84         ) = accountant.records(0);
85         assertEq(_asset, address(0));
86         assertEq(uint256(_amount), 0);
87         assertEq(_originalUser, address(0));
88         assertEq(uint256(_recovered), 0);
89         assertEq(accountant.totalAffected(defaultAsset), AFFECTED_TOKEN_AMOUNT);
90         assertTrue(accountant.isAffectedAsset(defaultAsset));
91         assertEq(accountant.totalRecovered(defaultAsset), 0);
92         assertEq(accountant.name(), "Nomad NFT");
93         assertEq(accountant.symbol(), "noNFT");
94         assertEq(accountant.baseURI(), "https://nft.nomad.xyz/");
95     }
96 
97     function recordCheckDefault() public {
98         recordCheck(defaultUser, defaultAmount, defaultAsset);
99     }
100 
101     function recordCheck(
102         address _user,
103         uint256 _amount,
104         address _asset
105     ) public {
106         uint256 _id = accountant.nextID();
107         uint256 _prevTotal = accountant.totalMinted(_asset);
108         // NFT does not exist before
109         vm.expectRevert("ERC721: owner query for nonexistent token");
110         accountant.ownerOf(_id);
111         // calling record emits event
112         vm.expectEmit(true, true, true, true, address(accountant));
113         emit ProcessFailure(_id, _asset, _user, _amount);
114         accountant.record(_asset, _user, _amount);
115         // next NFT is minted to user
116         assertEq(accountant.ownerOf(_id), _user);
117         // NFT has correct details
118         (
119             address nftAsset,
120             uint96 nftAmount,
121             address nftOriginalUser,
122             uint96 nftRecovered
123         ) = accountant.records(_id);
124         assertEq(nftAsset, _asset);
125         assertEq(uint256(nftAmount), _amount);
126         assertEq(nftOriginalUser, _user);
127         assertEq(uint256(nftRecovered), 0);
128         // state variables are appropriately updated
129         assertEq(accountant.nextID(), _id + 1);
130         assertEq(accountant.totalMinted(_asset), _prevTotal + _amount);
131     }
132 
133     function testFuzz_recordSuccess(
134         uint8 assetIndex,
135         address payable _user,
136         uint256 _amount
137     ) public {
138         address payable _asset = checkUserAndGetAsset(_user, assetIndex);
139         _amount = bound(_amount, 0, accountant.totalAffected(_asset));
140         recordCheck(_user, _amount, _asset);
141     }
142 
143     function test_recordSuccess() public {
144         recordCheckDefault();
145     }
146 
147     function test_recordSuccessForSameUserSameAssetTwice() public {
148         recordCheckDefault();
149         recordCheckDefault();
150     }
151 
152     function test_recordSuccessForSameAssetDifferentUser() public {
153         recordCheckDefault();
154         defaultUser = vm.addr(12345);
155         recordCheckDefault();
156     }
157 
158     function test_recordSuccessForDifferentAssettsSameUser() public {
159         recordCheckDefault();
160         defaultAsset = vm.addr(12345);
161         accountant.exposed_setAffectedAmount(
162             defaultAsset,
163             AFFECTED_TOKEN_AMOUNT
164         );
165         recordCheckDefault();
166     }
167 
168     function test_recordRevertsIfOverMint() public {
169         defaultAmount = AFFECTED_TOKEN_AMOUNT * 2;
170         vm.expectRevert("overmint");
171         accountant.record(defaultAsset, defaultUser, defaultAmount);
172         defaultAmount = AFFECTED_TOKEN_AMOUNT;
173         accountant.record(defaultAsset, defaultUser, defaultAmount);
174     }
175 
176     function test_recordRevertsIfNotAffectedAsset() public {
177         defaultAsset = vm.addr(99);
178         vm.expectRevert("overmint");
179         accountant.record(defaultAsset, defaultUser, defaultAmount);
180     }
181 
182     function testFuzz_recordRevertsIfNotAffectedAsset(
183         address _asset,
184         address _user,
185         uint256 _amount
186     ) public {
187         vm.assume(!accountant.isAffectedAsset(_asset));
188         // Fuzz only for addresses that can in fact receive an ERC721
189         // Filters through the address of the test contract, VM, and others.
190         //
191         // Create2Deployer
192         vm.assume(canAcceptNft(_user));
193         vm.assume(_amount != 0);
194         if (_user != address(0)) {
195             vm.expectRevert("overmint");
196             accountant.record(_asset, _user, _amount);
197         } else {
198             vm.expectRevert("ERC721: mint to the zero address");
199             accountant.record(_asset, _user, _amount);
200         }
201     }
202 
203     function test_transferReverts() public {
204         recordCheckDefault();
205         vm.prank(defaultUser);
206         vm.expectRevert("no transfers");
207         accountant.transferFrom(defaultUser, vm.addr(99), 0);
208         vm.expectRevert("no transfers");
209         accountant.safeTransferFrom(defaultUser, vm.addr(99), 0);
210         vm.expectRevert("no transfers");
211         accountant.safeTransferFrom(defaultUser, vm.addr(99), 0, "0x1234");
212     }
213 
214     function testFuzz_transferReverts(
215         address _user,
216         address _receiver,
217         uint256 _amount,
218         uint8 _assetIndex
219     ) public {
220         address payable _asset = checkUserAndGetAsset(_user, _assetIndex);
221         _amount = bound(_amount, 0, accountant.totalAffected(_asset));
222         recordCheck(_user, _amount, _asset);
223         vm.prank(_user);
224         vm.expectRevert("no transfers");
225         accountant.transferFrom(_user, _receiver, 0);
226         vm.expectRevert("no transfers");
227         accountant.safeTransferFrom(_user, _receiver, 0);
228         vm.expectRevert("no transfers");
229         accountant.safeTransferFrom(_user, _receiver, 0, "0x1234");
230     }
231 
232     function checkUserAndGetAsset(address _user, uint8 _assetIndex)
233         internal
234         returns (address payable _asset)
235     {
236         vm.assume(canAcceptNft(_user));
237         _assetIndex = uint8(bound(_assetIndex, 0, 13));
238         _asset = accountant.affectedAssets()[_assetIndex];
239     }
240 
241     function canAcceptNft(address _target) internal returns (bool _success) {
242         (_success, ) = _target.call(
243             abi.encodeWithSignature(
244                 "onERC721Received(address,address,uint256,bytes)",
245                 _target,
246                 address(0),
247                 0,
248                 ""
249             )
250         );
251         _success =
252             _success &&
253             _target != 0x4e59b44847b379578588920cA78FbF26c0B4956C &&
254             _target != address(0);
255     }
256 }
