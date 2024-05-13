1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "forge-std/Test.sol";
5 
6 import {NFTAccountant} from "../accountants/NFTAccountant.sol";
7 import {AccountantTest} from "./utils/AccountantTest.sol";
8 
9 contract NFTRecoveryAccountantTest is AccountantTest {
10     uint256 public constant AMOUNT_ONE = 12_000_000;
11     uint256 public constant AMOUNT_TWO = 8_000_000;
12 
13     event Recovery(
14         uint256 indexed _tokenId,
15         address indexed _asset,
16         address indexed _user,
17         uint256 _amount
18     );
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     function collectHelper(uint256 _amount) public {
23         // mint tokens to a random handler
24         // Adds modulo bias, but who cares
25         address handler = vm.addr((_amount % 76) + 1);
26         mockToken.mint(handler, _amount);
27         // approve the accountant to spend the tokens
28         vm.prank(handler);
29         mockToken.approve(address(accountant), _amount);
30         // call special collect function to move tokens into accountant
31         accountant.collect(handler, address(mockToken), _amount);
32     }
33 
34     function recoverCheck(uint256 _id) public {
35         (address _asst, , , uint256 _recovered) = accountant.records(_id);
36         uint256 _prevTotalRecovered = accountant.totalRecovered(_asst);
37         uint256 _recoverable = accountant.recoverable(_id);
38         address _user = accountant.ownerOf(_id);
39         // recover
40         vm.prank(_user);
41         // expect Recovery event emitted
42         vm.expectEmit(true, true, true, true, address(accountant));
43         emit Recovery(_id, _asst, _user, _recoverable);
44         accountant.exposed_recover(_id);
45         // totalRecovered is now incremented
46         assertEq(
47             accountant.totalRecovered(_asst),
48             _prevTotalRecovered + _recoverable
49         );
50         // recoverable is now zero
51         assertEq(accountant.recoverable(_id), 0);
52         // NFT's recovered field is incremented
53         (, , , uint256 _newRecovered) = accountant.records(_id);
54         assertEq(_newRecovered, _recovered + _recoverable);
55         // owner doesn't change
56         assertEq(accountant.ownerOf(_id), _user);
57     }
58 
59     function test_recoverableRevertsForNonExistentToken() public {
60         uint256 _id = 0;
61         // recoverable() reverts for a non-existent token
62         vm.expectRevert("recoverable: nonexistent token");
63         accountant.recoverable(_id);
64         // mint a few tokens
65         accountant.record(defaultAsset, defaultUser, defaultAmount);
66         collectHelper(AMOUNT_ONE);
67         // recoverable is now non-zero
68         uint256 expected = (defaultAmount *
69             accountant.totalCollected(defaultAsset)) /
70             accountant.totalAffected(defaultAsset);
71         assertEq(accountant.recoverable(_id), expected);
72     }
73 
74     function testFuzz_recoverableCorrect(
75         uint8 assetIndex,
76         uint256 famount,
77         uint256 collected
78     ) public {
79         address payable asset = checkUserAndGetAsset(defaultUser, assetIndex);
80         uint256 totalAffected = accountant.totalAffected(asset);
81         collected = bound(collected, 0, totalAffected);
82         famount = bound(famount, 0, totalAffected);
83 
84         uint256 id = accountant.nextID();
85         accountant.record(asset, defaultUser, famount);
86         accountant.exposed_setCollectedAmount(asset, collected);
87         uint256 recoverable = (collected * famount) / totalAffected;
88         assertEq(accountant.recoverable(id), recoverable);
89     }
90 
91     function test_totalCollectedUnchangedAfterRecord() public {
92         // totalCollected is zero
93         assertEq(accountant.totalCollected(defaultAsset), 0);
94         // mint a few tokens
95         accountant.record(defaultAsset, defaultUser, defaultAmount);
96         accountant.record(defaultAsset, defaultUser, defaultAmount);
97         accountant.record(defaultAsset, defaultUser, defaultAmount);
98         // totalCollected is not changed
99         assertEq(accountant.totalCollected(defaultAsset), 0);
100     }
101 
102     function tets_totalCollectedChangeOnlyWithCollect() public {
103         // totalCollected is not changed
104         assertEq(accountant.totalCollected(defaultAsset), 0);
105         // transfer tokens outside of established process
106         mockToken.mint(address(accountant), AMOUNT_ONE);
107         // totalCollected is not changed
108         assertEq(accountant.totalCollected(defaultAsset), 0);
109         // transfer tokens outside of established process
110         mockToken.mint(address(accountant), AMOUNT_ONE);
111         // totalCollected is not changed
112         assertEq(accountant.totalCollected(defaultAsset), 0);
113         // collect funds through established process
114         collectHelper(AMOUNT_ONE);
115         // totalCollected is now equal to funds collected
116         assertEq(accountant.totalCollected(defaultAsset), AMOUNT_ONE);
117     }
118 
119     function test_totalCollectedNotChangeWithRecover() public {
120         uint256 _id = 0;
121         accountant.record(defaultAsset, defaultUser, defaultAmount);
122         collectHelper(AMOUNT_ONE);
123         // totalCollected is now equal to funds collected
124         assertEq(accountant.totalCollected(defaultAsset), AMOUNT_ONE);
125         // recover
126         recoverCheck(_id);
127         // recovering does not change totalCollected
128         assertEq(accountant.totalCollected(defaultAsset), AMOUNT_ONE);
129         // collect more funds
130         collectHelper(AMOUNT_TWO);
131         // recovering some more
132         recoverCheck(_id);
133         // totalCollected is now equal to total lifetime funds collected
134         assertEq(
135             accountant.totalCollected(defaultAsset),
136             AMOUNT_ONE + AMOUNT_TWO
137         );
138     }
139 
140     function test_totalRecoeredNotChangedAfterRecord() public {
141         // totalRecovered is zero
142         assertEq(accountant.totalRecovered(defaultAsset), 0);
143         // mint a few tokens
144         accountant.record(defaultAsset, defaultUser, defaultAmount);
145         accountant.record(defaultAsset, defaultUser, defaultAmount);
146         accountant.record(defaultAsset, defaultUser, defaultAmount);
147         // totalRecovered is not changed
148         assertEq(accountant.totalRecovered(defaultAsset), 0);
149     }
150 
151     function test_totalRecoveredNotChangeAfterCollect() public {
152         accountant.record(defaultAsset, defaultUser, defaultAmount);
153         // collect funds
154         collectHelper(AMOUNT_ONE);
155         // totalRecovered is not changed
156         assertEq(accountant.totalRecovered(defaultAsset), 0);
157     }
158 
159     function test_totalRevoeredNotChangeAfterTransferOutsideCollect() public {
160         // transfer tokens outside of established process
161         mockToken.mint(address(accountant), AMOUNT_ONE);
162         // totalRecovered is not changed
163         assertEq(accountant.totalRecovered(defaultAsset), 0);
164     }
165 
166     /// @notice Produce a fuzzed test scenario of 64 random users, who bridge back 64 random amounts
167     /// on each of the 64 different combinations of (total affected, collected Assets).
168     function testFuzz_totalRecoveredCorrectAfterUsersRecover(
169         address[8] memory users,
170         uint192[8] memory amounts,
171         uint256 totalAffected,
172         uint256 collectedAssets
173     ) public {
174         // Total affected MUST not be 0
175         if (totalAffected == 0) totalAffected = 100_000_000;
176         accountant.exposed_setAffectedAmount(defaultAsset, totalAffected);
177         // Total collected MUST be between 1 and totalAffected (inclusive)
178         uint256 collected = bound(collectedAssets, 1, totalAffected);
179         collectHelper(collected);
180         // Keep track of how many have been bridged back (instead of the circulation)
181         uint256 bridgedSum;
182         for (uint256 i; i < 8; i++) {
183             // Make sure that the defaultUser is not the address(0)
184             if (users[i] == address(0)) users[i] = address(0xBEEF);
185             // Make sure that the defaultUser can receive the NFT
186             (bool success, ) = users[i].call(
187                 abi.encodeWithSignature(
188                     "onERC721Received(address,address,uint256,bytes)",
189                     address(this),
190                     address(0),
191                     0,
192                     ""
193                 )
194             );
195             // if the defaultUser can't receive an ERC721, it's some test contract (e.g VM)
196             // we turn them into a regular EOA
197             if (!success) users[i] = address(0xBEEEEFFFEFEFEFEFEFEFEF);
198             // The amount MUST be between 0 and the total Affected minus the ones that have been bridged already
199             // The defaultUser can't have more than that, as total affected is the upper bound for the total assets
200             // that were hacked and bridgedSum is the sum of all the funds that other users have already bridged.
201             // Thus the respective defaultUser can have up to their difference
202             uint256 famount = bound(
203                 uint256(amounts[i]),
204                 0,
205                 totalAffected - bridgedSum
206             );
207             bridgedSum += famount;
208             uint256 prevTotalRecovered = accountant.totalRecovered(
209                 defaultAsset
210             );
211             uint256 id = accountant.nextID();
212             if (
213                 accountant.totalMinted(defaultAsset) + famount > totalAffected
214             ) {
215                 vm.expectRevert("overmint");
216                 accountant.record(defaultAsset, users[i], famount);
217                 // This defaultAsset has been overminted and we should check the next one
218                 return;
219             }
220             accountant.record(defaultAsset, users[i], famount);
221             uint256 recoverable = accountant.recoverable(id);
222             address fuser = accountant.ownerOf(id);
223             if (recoverable == 0) {
224                 vm.expectRevert("currently fully recovered");
225                 vm.prank(fuser);
226                 accountant.exposed_recover(id);
227                 return;
228             }
229             recoverCheck(id);
230             assertEq(
231                 accountant.totalRecovered(defaultAsset),
232                 prevTotalRecovered + recoverable
233             );
234         }
235     }
236 
237     function test_recoverNonexistentToken() public {
238         // recovering fails for nonexistent token
239         vm.expectRevert("ERC721: owner query for nonexistent token");
240         accountant.exposed_recover(1);
241     }
242 
243     // can't recover if there's no funds in contract
244     function test_recoverNoCollect() public {
245         // mint token
246         accountant.record(defaultAsset, defaultUser, defaultAmount);
247         vm.prank(defaultUser);
248         // recovering fails with no collect
249         vm.expectRevert("currently fully recovered");
250         accountant.exposed_recover(0);
251     }
252 
253     // collect -> recover -> recover FAIL (can't recover twice if there's no change in funds)
254     function test_recoverTwiceNoCollect() public {
255         // mint token
256         accountant.record(defaultAsset, defaultUser, defaultAmount);
257         // collect funds
258         collectHelper(AMOUNT_ONE);
259         // recovering once works
260         recoverCheck(0);
261         // recovering the same token again before a collect doesn't work
262         vm.prank(defaultUser);
263         vm.expectRevert("currently fully recovered");
264         accountant.exposed_recover(0);
265     }
266 
267     // only NFT holder can call recover
268     function test_onlyOwnerRecover() public {
269         // mint token
270         accountant.record(defaultAsset, defaultUser, defaultAmount);
271         // collect funds
272         collectHelper(AMOUNT_ONE);
273         // only NFT holder can recover
274         vm.expectRevert("only NFT holder can recover");
275         accountant.exposed_recover(0);
276     }
277 
278     // mint -> collect -> recover
279     function test_recoverOne() public {
280         // mint token
281         accountant.record(defaultAsset, defaultUser, defaultAmount);
282         // collect funds
283         collectHelper(AMOUNT_ONE);
284         // recover
285         recoverCheck(0);
286     }
287 
288     // collect -> mint -> recover
289     function test_recoverTwo() public {
290         // collect funds
291         collectHelper(AMOUNT_ONE);
292         // mint token
293         accountant.record(defaultAsset, defaultUser, defaultAmount);
294         // recover
295         recoverCheck(0);
296     }
297 
298     // collect -> recover -> collect -> recover (can recover twice if there's more funds)
299     function test_recoverContinuous() public {
300         // mint token
301         accountant.record(defaultAsset, defaultUser, defaultAmount);
302         // collect funds
303         collectHelper(AMOUNT_ONE);
304         // recover
305         recoverCheck(0);
306         // collect funds
307         collectHelper(AMOUNT_ONE);
308         // recover
309         recoverCheck(0);
310     }
311 
312     function test_remove() public {
313         // collect funds within normal process
314         collectHelper(30_000_000);
315         // transfer tokens outside of established process
316         mockToken.mint(address(accountant), 30_000_000);
317         // remove sends funds to fundsRecipient
318         vm.expectEmit(true, true, true, true, address(mockToken));
319         emit Transfer(address(accountant), fundsRecipient, 15_000_000);
320         accountant.remove(address(mockToken), 15_000_000);
321         // recovering functions as normal afterward
322         accountant.record(defaultAsset, defaultUser, 1_000_000);
323         recoverCheck(0);
324     }
325 
326     function test_removeOnlyOwner() public {
327         // collect funds
328         mockToken.mint(address(accountant), 200);
329         // prank non-owner address
330         vm.prank(fundsRecipient);
331         vm.expectRevert("Ownable: caller is not the owner");
332         accountant.remove(address(mockToken), 100);
333         accountant.remove(address(mockToken), 100);
334         // 100 removed
335         assertEq(mockToken.balanceOf(address(accountant)), 100);
336     }
337 
338     function test_collectSuccesfully() public {
339         uint256 _amount = 123456;
340         // mint tokens to a random handler
341         address handler = vm.addr(112233);
342         mockToken.mint(handler, _amount);
343         // approve the accountant to spend the tokens
344         vm.prank(handler);
345         mockToken.approve(address(accountant), _amount);
346         // totalCollected should start at zero
347         assertEq(accountant.totalCollected(address(mockToken)), 0);
348         // call special collect function to move tokens into accountant
349         vm.expectEmit(true, true, true, true, address(mockToken));
350         emit Transfer(handler, address(accountant), _amount);
351         accountant.collect(handler, address(mockToken), _amount);
352         // totalCollected should be incremented
353         assertEq(accountant.totalCollected(address(mockToken)), _amount);
354     }
355 
356     function testFuzz_collectSuccesfully(uint256 _amount, address handler)
357         public
358     {
359         vm.assume(handler != address(0));
360         mockToken.mint(handler, _amount);
361         // approve the accountant to spend the tokens
362         vm.prank(handler);
363         mockToken.approve(address(accountant), _amount);
364         // totalCollected should start at zero
365         assertEq(accountant.totalCollected(address(mockToken)), 0);
366         // call special collect function to move tokens into accountant
367         vm.expectEmit(true, true, true, true, address(mockToken));
368         emit Transfer(handler, address(accountant), _amount);
369         accountant.collect(handler, address(mockToken), _amount);
370         // totalCollected should be incremented
371         assertEq(accountant.totalCollected(address(mockToken)), _amount);
372     }
373 
374     function test_collectOnlyOwner() public {
375         // prank non-owner address
376         vm.prank(fundsRecipient);
377         vm.expectRevert("Ownable: caller is not the owner");
378         accountant.collect(defaultUser, address(mockToken), 100);
379         // prank as a defaultUser with tokens
380         uint256 _amount = 123;
381         mockToken.mint(defaultUser, _amount);
382         vm.prank(defaultUser);
383         mockToken.approve(address(accountant), _amount);
384         accountant.collect(defaultUser, address(mockToken), 100);
385     }
386 
387     // helper function to recover the full balance of the contract
388     function recoverFullBalanceHelper(uint256 _balance) public {
389         // loop through tokens to check recoverable amount
390         uint256 _totalRecoverable;
391         for (uint256 _id = 0; _id < accountant.nextID(); _id++) {
392             _totalRecoverable += accountant.recoverable(_id);
393         }
394         assertEq(mockToken.balanceOf(address(accountant)), _balance);
395         assertEq(_totalRecoverable, _balance);
396         // loop through tokens to recover
397         for (uint256 _id = 0; _id < accountant.nextID(); _id++) {
398             recoverCheck(_id);
399         }
400         // accountant should be empty now
401         assertEq(mockToken.balanceOf(address(accountant)), 0);
402     }
403 
404     function test_recoverFullBalance() public {
405         // mint tokens adding up to entire supply
406         accountant.record(defaultAsset, defaultUser, defaultAmount);
407         accountant.record(defaultAsset, defaultUser, defaultAmount);
408         accountant.record(defaultAsset, defaultUser, defaultAmount);
409         accountant.record(
410             defaultAsset,
411             defaultUser,
412             AFFECTED_TOKEN_AMOUNT - (defaultAmount * 3)
413         );
414         // collect funds
415         collectHelper(AMOUNT_ONE);
416         // check the full balance is recoverable
417         recoverFullBalanceHelper(AMOUNT_ONE);
418         // collect more funds
419         collectHelper(AMOUNT_TWO);
420         // check the full balance is recoverable
421         // a second time
422         recoverFullBalanceHelper(AMOUNT_TWO);
423     }
424 
425     // recovering the entire affected token amount is possible
426     function test_recoverAffectedAmount() public {
427         // mint tokens adding up to entire supply
428         accountant.record(defaultAsset, defaultUser, defaultAmount);
429         accountant.record(defaultAsset, defaultUser, defaultAmount);
430         accountant.record(defaultAsset, defaultUser, defaultAmount);
431         accountant.record(
432             defaultAsset,
433             defaultUser,
434             AFFECTED_TOKEN_AMOUNT - (defaultAmount * 3)
435         );
436         // collect funds
437         collectHelper(AFFECTED_TOKEN_AMOUNT);
438         // check the full balance is recoverable
439         recoverFullBalanceHelper(AFFECTED_TOKEN_AMOUNT);
440     }
441 
442     // recovering even more than the affected token amount is possible
443     // if collect more funds than affectedAssetAmounts
444     function test_recoverOverAffectedAmount() public {
445         // mint tokens adding up to entire supply
446         accountant.record(defaultAsset, defaultUser, defaultAmount);
447         accountant.record(defaultAsset, defaultUser, defaultAmount);
448         accountant.record(defaultAsset, defaultUser, defaultAmount);
449         accountant.record(
450             defaultAsset,
451             defaultUser,
452             AFFECTED_TOKEN_AMOUNT - (defaultAmount * 3)
453         );
454         // collect funds
455         collectHelper(AFFECTED_TOKEN_AMOUNT * 2);
456         // check the full balance is recoverable
457         recoverFullBalanceHelper(AFFECTED_TOKEN_AMOUNT * 2);
458     }
459 
460     function checkUserAndGetAsset(address _user, uint8 _assetIndex)
461         internal
462         returns (address payable _asset)
463     {
464         vm.assume(canAcceptNft(_user));
465         _assetIndex = uint8(bound(_assetIndex, 0, 13));
466         _asset = accountant.affectedAssets()[_assetIndex];
467     }
468 
469     function canAcceptNft(address _target) internal returns (bool _success) {
470         (_success, ) = _target.call(
471             abi.encodeWithSignature(
472                 "onERC721Received(address,address,uint256,bytes)",
473                 _target,
474                 address(0),
475                 0,
476                 ""
477             )
478         );
479         _success =
480             _success &&
481             _target != 0x4e59b44847b379578588920cA78FbF26c0B4956C &&
482             _target != address(0);
483     }
484 }
