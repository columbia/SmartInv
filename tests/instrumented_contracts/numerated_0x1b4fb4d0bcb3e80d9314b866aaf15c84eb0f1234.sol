1 /*
2 This file is part of the DAO.
3 000000000000000000000000bb9bc244d798123fde783fcc1c72d3bb8c189413
4 
5 Account 0xB3267B3B37a1C153Ca574c3A50359f9d1613F95d
6 dthPool 0xB256D572885A5246DDbF548F39da57f5f8074b9a
7 
8 Hello all! I just deployed the first DTHPool (Delegate) in the real net.
9 The delegate in this contract is myself. My intention is not to be a stable delegate but to construct a repository of delegates where DTH’s can choose.
10 I tested to delegate and undelegate some tokens. I also set up the votes for the proposals made to the DAO until now. 
11 If any body wants to delegate me some tokens, he will be wellcome!. You can also check the votes set up and his motivations. 
12 I'll appreciate any feedback.
13 If any body wants to be a delegate, I’m absolutely open to help him to deploy the contract.
14 
15 
16 The DAO is free software: you can redistribute it and/or modify
17 it under the terms of the GNU lesser General Public License as published by
18 the Free Software Foundation, either version 3 of the License, or
19 (at your option) any later version.
20 
21 The DAO is distributed in the hope that it will be useful,
22 but WITHOUT ANY WARRANTY; without even the implied warranty of
23 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
24 GNU lesser General Public License for more details.
25 
26 You should have received a copy of the GNU lesser General Public License
27 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
28 */
29 
30 /*
31 This file is part of the DAO.
32 
33 The DAO is free software: you can redistribute it and/or modify
34 it under the terms of the GNU lesser General Public License as published by
35 the Free Software Foundation, either version 3 of the License, or
36 (at your option) any later version.
37 
38 The DAO is distributed in the hope that it will be useful,
39 but WITHOUT ANY WARRANTY; without even the implied warranty of
40 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
41 GNU lesser General Public License for more details.
42 
43 You should have received a copy of the GNU lesser General Public License
44 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
45 */
46 
47 
48 // <ORACLIZE_API>
49 /*
50 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
51 
52 
53 
54 Permission is hereby granted, free of charge, to any person obtaining a copy
55 of this software and associated documentation files (the "Software"), to deal
56 in the Software without restriction, including without limitation the rights
57 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
58 copies of the Software, and to permit persons to whom the Software is
59 furnished to do so, subject to the following conditions:
60 
61 
62 
63 The above copyright notice and this permission notice shall be included in
64 all copies or substantial portions of the Software.
65 
66 
67 
68 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
69 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
70 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
71 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
72 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
73 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
74 THE SOFTWARE.
75 */
76 
77 contract OraclizeI {
78     address public cbAddress;
79     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
80     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
81     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
82     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
83     function getPrice(string _datasource) returns (uint _dsprice);
84     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
85     function useCoupon(string _coupon);
86     function setProofType(byte _proofType);
87 }
88 contract OraclizeAddrResolverI {
89     function getAddress() returns (address _addr);
90 }
91 contract usingOraclize {
92     uint constant day = 60*60*24;
93     uint constant week = 60*60*24*7;
94     uint constant month = 60*60*24*30;
95     byte constant proofType_NONE = 0x00;
96     byte constant proofType_TLSNotary = 0x10;
97     byte constant proofStorage_IPFS = 0x01;
98     uint8 constant networkID_auto = 0;
99     uint8 constant networkID_mainnet = 1;
100     uint8 constant networkID_testnet = 2;
101     uint8 constant networkID_morden = 2;
102     uint8 constant networkID_consensys = 161;
103 
104     OraclizeAddrResolverI OAR;
105 
106     OraclizeI oraclize;
107     modifier oraclizeAPI {
108         address oraclizeAddr = OAR.getAddress();
109         if (oraclizeAddr == 0){
110             oraclize_setNetwork(networkID_auto);
111             oraclizeAddr = OAR.getAddress();
112         }
113         oraclize = OraclizeI(oraclizeAddr);
114         _
115     }
116     modifier coupon(string code){
117         oraclize = OraclizeI(OAR.getAddress());
118         oraclize.useCoupon(code);
119         _
120     }
121 
122     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
123         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
124             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
125             return true;
126         }
127         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
128             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
129             return true;
130         }
131         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
132             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
133             return true;
134         }
135         return false;
136     }
137 
138     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query.value(price)(0, datasource, arg);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query.value(price)(timestamp, datasource, arg);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
152     }
153     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
157     }
158     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource);
160         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
161         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
162     }
163     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
167     }
168     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
172     }
173     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
177     }
178     function oraclize_cbAddress() oraclizeAPI internal returns (address){
179         return oraclize.cbAddress();
180     }
181     function oraclize_setProof(byte proofP) oraclizeAPI internal {
182         return oraclize.setProofType(proofP);
183     }
184 
185     function getCodeSize(address _addr) constant internal returns(uint _size) {
186         assembly {
187             _size := extcodesize(_addr)
188         }
189     }
190 
191 
192     function parseAddr(string _a) internal returns (address){
193         bytes memory tmp = bytes(_a);
194         uint160 iaddr = 0;
195         uint160 b1;
196         uint160 b2;
197         for (uint i=2; i<2+2*20; i+=2){
198             iaddr *= 256;
199             b1 = uint160(tmp[i]);
200             b2 = uint160(tmp[i+1]);
201             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
202             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
203             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
204             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
205             iaddr += (b1*16+b2);
206         }
207         return address(iaddr);
208     }
209 
210 
211     function strCompare(string _a, string _b) internal returns (int) {
212         bytes memory a = bytes(_a);
213         bytes memory b = bytes(_b);
214         uint minLength = a.length;
215         if (b.length < minLength) minLength = b.length;
216         for (uint i = 0; i < minLength; i ++)
217             if (a[i] < b[i])
218                 return -1;
219             else if (a[i] > b[i])
220                 return 1;
221         if (a.length < b.length)
222             return -1;
223         else if (a.length > b.length)
224             return 1;
225         else
226             return 0;
227    }
228 
229     function indexOf(string _haystack, string _needle) internal returns (int)
230     {
231         bytes memory h = bytes(_haystack);
232         bytes memory n = bytes(_needle);
233         if(h.length < 1 || n.length < 1 || (n.length > h.length))
234             return -1;
235         else if(h.length > (2**128 -1))
236             return -1;
237         else
238         {
239             uint subindex = 0;
240             for (uint i = 0; i < h.length; i ++)
241             {
242                 if (h[i] == n[0])
243                 {
244                     subindex = 1;
245                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
246                     {
247                         subindex++;
248                     }
249                     if(subindex == n.length)
250                         return int(i);
251                 }
252             }
253             return -1;
254         }
255     }
256 
257     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
258         bytes memory _ba = bytes(_a);
259         bytes memory _bb = bytes(_b);
260         bytes memory _bc = bytes(_c);
261         bytes memory _bd = bytes(_d);
262         bytes memory _be = bytes(_e);
263         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
264         bytes memory babcde = bytes(abcde);
265         uint k = 0;
266         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
267         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
268         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
269         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
270         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
271         return string(babcde);
272     }
273 
274     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
275         return strConcat(_a, _b, _c, _d, "");
276     }
277 
278     function strConcat(string _a, string _b, string _c) internal returns (string) {
279         return strConcat(_a, _b, _c, "", "");
280     }
281 
282     function strConcat(string _a, string _b) internal returns (string) {
283         return strConcat(_a, _b, "", "", "");
284     }
285 
286     // parseInt
287     function parseInt(string _a) internal returns (uint) {
288         return parseInt(_a, 0);
289     }
290 
291     // parseInt(parseFloat*10^_b)
292     function parseInt(string _a, uint _b) internal returns (uint) {
293         bytes memory bresult = bytes(_a);
294         uint mint = 0;
295         bool decimals = false;
296         for (uint i=0; i<bresult.length; i++){
297             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
298                 if (decimals){
299                    if (_b == 0) break;
300                     else _b--;
301                 }
302                 mint *= 10;
303                 mint += uint(bresult[i]) - 48;
304             } else if (bresult[i] == 46) decimals = true;
305         }
306         return mint;
307     }
308 
309 
310 }
311 // </ORACLIZE_API>
312 
313 
314 /*
315 Basic, standardized Token contract with no "premine". Defines the functions to
316 check token balances, send tokens, send tokens on behalf of a 3rd party and the
317 corresponding approval process. Tokens need to be created by a derived
318 contract (e.g. TokenCreation.sol).
319 
320 Thank you ConsenSys, this contract originated from:
321 https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
322 Which is itself based on the Ethereum standardized contract APIs:
323 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
324 */
325 
326 /// @title Standard Token Contract.
327 
328 contract TokenInterface {
329     mapping (address => uint256) balances;
330     mapping (address => mapping (address => uint256)) allowed;
331 
332     /// Public variables of the token, all used for display 
333     string public name;
334     string public symbol;
335     uint8 public decimals;
336     string public standard = 'Token 0.1';
337 
338     /// Total amount of tokens
339     uint256 public totalSupply;
340 
341     /// @param _owner The address from which the balance will be retrieved
342     /// @return The balance
343     function balanceOf(address _owner) constant returns (uint256 balance);
344 
345     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
346     /// @param _to The address of the recipient
347     /// @param _amount The amount of tokens to be transferred
348     /// @return Whether the transfer was successful or not
349     function transfer(address _to, uint256 _amount) returns (bool success);
350 
351     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
352     /// is approved by `_from`
353     /// @param _from The address of the origin of the transfer
354     /// @param _to The address of the recipient
355     /// @param _amount The amount of tokens to be transferred
356     /// @return Whether the transfer was successful or not
357     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
358 
359     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
360     /// its behalf
361     /// @param _spender The address of the account able to transfer the tokens
362     /// @param _amount The amount of tokens to be approved for transfer
363     /// @return Whether the approval was successful or not
364     function approve(address _spender, uint256 _amount) returns (bool success);
365 
366     /// @param _owner The address of the account owning tokens
367     /// @param _spender The address of the account able to transfer the tokens
368     /// @return Amount of remaining tokens of _owner that _spender is allowed
369     /// to spend
370     function allowance(
371         address _owner,
372         address _spender
373     ) constant returns (uint256 remaining);
374 
375     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
376     event Approval(
377         address indexed _owner,
378         address indexed _spender,
379         uint256 _amount
380     );
381 }
382 
383 contract tokenRecipient { 
384     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
385 }
386 
387 contract Token is TokenInterface {
388     // Protects users by preventing the execution of method calls that
389     // inadvertently also transferred ether
390     modifier noEther() {if (msg.value > 0) throw; _}
391 
392     function balanceOf(address _owner) constant returns (uint256 balance) {
393         return balances[_owner];
394     }
395 
396     function transfer(address _to, uint256 _amount) noEther returns (bool success) {
397         if (balances[msg.sender] >= _amount && _amount > 0) {
398             balances[msg.sender] -= _amount;
399             balances[_to] += _amount;
400             Transfer(msg.sender, _to, _amount);
401             return true;
402         } else {
403            return false;
404         }
405     }
406 
407     function transferFrom(
408         address _from,
409         address _to,
410         uint256 _amount
411     ) noEther returns (bool success) {
412 
413         if (balances[_from] >= _amount
414             && allowed[_from][msg.sender] >= _amount
415             && _amount > 0) {
416 
417             balances[_to] += _amount;
418             balances[_from] -= _amount;
419             allowed[_from][msg.sender] -= _amount;
420             Transfer(_from, _to, _amount);
421             return true;
422         } else {
423             return false;
424         }
425     }
426 
427     function approve(address _spender, uint256 _amount) returns (bool success) {
428         allowed[msg.sender][_spender] = _amount;
429         Approval(msg.sender, _spender, _amount);
430         return true;
431     }
432     
433     /// Allow another contract to spend some tokens in your behalf 
434     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
435         returns (bool success) {
436         allowed[msg.sender][_spender] = _value;
437         tokenRecipient spender = tokenRecipient(_spender);
438         spender.receiveApproval(msg.sender, _value, this, _extraData);
439         return true;
440     }
441 
442     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
443         return allowed[_owner][_spender];
444     }
445 }
446 
447 
448 /*
449 This file is part of the DAO.
450 
451 The DAO is free software: you can redistribute it and/or modify
452 it under the terms of the GNU lesser General Public License as published by
453 the Free Software Foundation, either version 3 of the License, or
454 (at your option) any later version.
455 
456 The DAO is distributed in the hope that it will be useful,
457 but WITHOUT ANY WARRANTY; without even the implied warranty of
458 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
459 GNU lesser General Public License for more details.
460 
461 You should have received a copy of the GNU lesser General Public License
462 along with the DAO.  If not, see <http://www.gnu.org/licenses/>.
463 */
464 
465 /////////////////////
466 // There is a solidity bug in the return parameters that it's not solved
467 // when the bug is solved, the import from DAO is more clean.
468 // In the meantime, a workaround proxy is defined
469 
470 // Uncoment this line when error fixed
471 // import "./DAO.sol";
472 
473 // Workaround proxy remove when fixed
474 contract DAO {
475     function proposals(uint _proposalID) returns(
476         address recipient,
477         uint amount,
478         uint descriptionIdx,
479         uint votingDeadline,
480         bool open,
481         bool proposalPassed,
482         bytes32 proposalHash,
483         uint proposalDeposit,
484         bool newCurator
485     );
486 
487     function transfer(address _to, uint256 _amount) returns (bool success);
488 
489     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
490 
491     function vote(
492         uint _proposalID,
493         bool _supportsProposal
494     ) returns (uint _voteID);
495 
496     function balanceOf(address _owner) constant returns (uint256 balance);
497 }
498 // End of workaround proxy
499 ////////////////////
500 
501 
502 contract DTHPoolInterface {
503 
504     // delegae url
505     string public delegateUrl;
506 
507     // Max time the tokens can be blocked.
508     // The real voting in the DAO will be called in the last moment in order
509     // to block the tokens for the minimum time. This parameter defines the
510     // seconds before the voting period ends that the vote can be performed
511     uint maxTimeBlocked;
512 
513 
514     // Address of the delegate
515     address public delegate;
516 
517     // The DAO contract
518     address public daoAddress;
519 
520     struct ProposalStatus {
521 
522         // True when the delegate sets the vote
523         bool voteSet;
524 
525         // True if the proposal should ve voted
526         bool willVote;
527 
528         // True if the proposal should be accepted.
529         bool suportProposal;
530 
531         // True when the vote is performed;
532         bool executed;
533 
534         // Proposal votingDeadline
535         uint votingDeadline;
536 
537         // String set by the delegator with the motivation
538         string motivation;
539     }
540 
541     // Statuses of the diferent proposal
542     mapping (uint => ProposalStatus) public proposalStatuses;
543 
544 
545     // Index of proposals by oraclizeId
546     mapping (bytes32 => uint) public oraclizeId2proposalId;
547 
548     /// @dev Constructor setting the dao address and the delegate
549     /// @param _daoAddress address of the DAO
550     /// @param _delegate adddress of the delegate.
551     /// @param _maxTimeBlocked the maximum time the tokens will be blocked
552     /// @param _delegateName Name of the delegate
553     /// @param _delegateUrl Url of the delegate
554     /// @param _tokenSymbol token  symbol.
555     // DTHPool(address _daoAddress, address _delegate, uint _maxTimeBlocked, string _delegateName, string _delegateUrl, string _tokenSymbol);
556 
557 
558     /// @notice send votes to this contract.
559     /// @param _amount Tokens that will be transfered to the pool.
560     /// @return Whether the transfer was successful or not
561     function delegateDAOTokens(uint _amount) returns (bool _success);
562 
563     /// Returns DAO tokens to the original
564     /// @param _amount that will be transfered back to the owner.
565     /// @return Whether the transfer was successful or not
566     function undelegateDAOTokens(uint _amount) returns (bool _success);
567 
568 
569     /// @notice This method will be called by the delegate to publish what will
570     /// be his vote in a specific proposal.
571     /// @param _proposalID The proposal to set the vote.
572     /// @param _willVote true If the proposal will be voted.
573     /// @param _supportsProposal What will be the vote.
574     function setVoteIntention(
575         uint _proposalID,
576         bool _willVote,
577         bool _supportsProposal,
578         string _motivation
579     ) returns (bool _success);
580 
581     /// @notice This method will be doing the actual voting in the DAO
582     /// for the _proposalID
583     /// @param _proposalID The proposal to set the vote.
584     /// @return _finalized true if this vote Proposal must not be executed again.
585     function executeVote(uint _proposalID) returns (bool _finalized);
586 
587 
588     /// @notice This function is intended because if some body sends tokens
589     /// directly to this contract, the tokens can be sent to the delegate
590     function fixTokens() returns (bool _success);
591 
592 
593     /// @notice If some body sends ether to this contract, the delegate will be
594     /// able to extract it.
595     function getEther() returns (uint _amount);
596 
597     /// @notice Called when some body delegates token to the pool
598     event Delegate(address indexed _from, uint256 _amount);
599 
600     /// @notice Called when some body undelegates token to the pool
601     event Undelegate(address indexed _from, uint256 _amount);
602 
603     /// @notice Called when the delegate set se vote intention
604     event VoteIntentionSet(uint indexed _proposalID, bool _willVote, bool _supportsProposal);
605 
606     /// @notice Called when the vote is executed in the DAO
607     event VoteExecuted(uint indexed _proposalID);
608 
609 }
610 
611 contract DTHPool is DTHPoolInterface, Token, usingOraclize {
612 
613     modifier onlyDelegate() {if (msg.sender != delegate) throw; _}
614 
615     // DTHPool(address _daoAddress, address _delegate, uint _maxTimeBlocked, string _delegateName, string _delegateUrl, string _tokenSymbol);
616 
617     function DTHPool(
618         address _daoAddress,
619         address _delegate,
620         uint _maxTimeBlocked,
621         string _delegateName,
622         string _delegateUrl,
623         string _tokenSymbol
624     ) {
625         daoAddress = _daoAddress;
626         delegate = _delegate;
627         delegateUrl = _delegateUrl;
628         maxTimeBlocked = _maxTimeBlocked;
629         name = _delegateName;
630         symbol = _tokenSymbol;
631         decimals = 16;
632         oraclize_setNetwork(networkID_auto);
633     }
634 
635     function delegateDAOTokens(uint _amount) returns (bool _success) {
636         DAO dao = DAO(daoAddress);
637         if (!dao.transferFrom(msg.sender, address(this), _amount)) {
638             throw;
639         }
640 
641         balances[msg.sender] += _amount;
642         totalSupply += _amount;
643         Delegate(msg.sender, _amount);
644         return true;
645     }
646 
647     function undelegateDAOTokens(uint _amount) returns (bool _success) {
648         DAO dao = DAO(daoAddress);
649         if (_amount > balances[msg.sender]) {
650             throw;
651         }
652 
653         if (!dao.transfer(msg.sender, _amount)) {
654             throw;
655         }
656 
657         balances[msg.sender] -= _amount;
658         totalSupply -= _amount;
659         Undelegate(msg.sender, _amount);
660         return true;
661     }
662 
663     function setVoteIntention(
664         uint _proposalID,
665         bool _willVote,
666         bool _supportsProposal,
667         string _motivation
668     ) onlyDelegate returns (bool _success) {
669         DAO dao = DAO(daoAddress);
670 
671         ProposalStatus proposalStatus = proposalStatuses[_proposalID];
672 
673         if (proposalStatus.voteSet) {
674             throw;
675         }
676 
677         var (,,,votingDeadline, ,,,,newCurator) = dao.proposals(_proposalID);
678 
679         if (votingDeadline < now || newCurator ) {
680             throw;
681         }
682 
683         proposalStatus.voteSet = true;
684         proposalStatus.willVote = _willVote;
685         proposalStatus.suportProposal = _supportsProposal;
686         proposalStatus.votingDeadline = votingDeadline;
687         proposalStatus.motivation = _motivation;
688 
689         VoteIntentionSet(_proposalID, _willVote, _supportsProposal);
690 
691         if (!_willVote) {
692             proposalStatus.executed = true;
693             VoteExecuted(_proposalID);
694         }
695 
696         bool finalized = executeVote(_proposalID);
697 
698         if ((!finalized)&&(address(OAR) != 0)) {
699             bytes32 oraclizeId = oraclize_query(votingDeadline - maxTimeBlocked +15, "URL", "");
700 
701             oraclizeId2proposalId[oraclizeId] = _proposalID;
702         }
703 
704         return true;
705     }
706 
707     function executeVote(uint _proposalID) returns (bool _finalized) {
708         DAO dao = DAO(daoAddress);
709         ProposalStatus proposalStatus = proposalStatuses[_proposalID];
710 
711         if (!proposalStatus.voteSet
712             || now > proposalStatus.votingDeadline
713             || !proposalStatus.willVote
714             || proposalStatus.executed) {
715 
716             return true;
717         }
718 
719         if (now < proposalStatus.votingDeadline - maxTimeBlocked) {
720             return false;
721         }
722 
723         dao.vote(_proposalID, proposalStatus.suportProposal);
724         proposalStatus.executed = true;
725         VoteExecuted(_proposalID);
726 
727         return true;
728     }
729 
730     function __callback(bytes32 oid, string result) {
731         uint proposalId = oraclizeId2proposalId[oid];
732         executeVote(proposalId);
733         oraclizeId2proposalId[oid] = 0;
734     }
735 
736     function fixTokens() returns (bool _success) {
737         DAO dao = DAO(daoAddress);
738         uint ownedTokens = dao.balanceOf(this);
739         if (ownedTokens < totalSupply) {
740             throw;
741         }
742         uint fixTokens = ownedTokens - totalSupply;
743 
744         if (fixTokens == 0) {
745             return true;
746         }
747 
748         balances[delegate] += fixTokens;
749         totalSupply += fixTokens;
750 
751         return true;
752     }
753 
754     function getEther() onlyDelegate returns (uint _amount) {
755         uint amount = this.balance;
756 
757         if (!delegate.call.value(amount)()) {
758             throw;
759         }
760 
761         return amount;
762     }
763 
764 }