1 pragma solidity ^0.4.23;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) public constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 library ECTools {
51 
52     // @dev Recovers the address which has signed a message
53     // @thanks https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
54     function recoverSigner(bytes32 _hashedMsg, string _sig) public pure returns (address) {
55         require(_hashedMsg != 0x00);
56 
57         // need this for test RPC
58         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
59         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashedMsg));
60 
61         if (bytes(_sig).length != 132) {
62             return 0x0;
63         }
64         bytes32 r;
65         bytes32 s;
66         uint8 v;
67         bytes memory sig = hexstrToBytes(substring(_sig, 2, 132));
68         assembly {
69             r := mload(add(sig, 32))
70             s := mload(add(sig, 64))
71             v := byte(0, mload(add(sig, 96)))
72         }
73         if (v < 27) {
74             v += 27;
75         }
76         if (v < 27 || v > 28) {
77             return 0x0;
78         }
79         return ecrecover(prefixedHash, v, r, s);
80     }
81 
82     // @dev Verifies if the message is signed by an address
83     function isSignedBy(bytes32 _hashedMsg, string _sig, address _addr) public pure returns (bool) {
84         require(_addr != 0x0);
85 
86         return _addr == recoverSigner(_hashedMsg, _sig);
87     }
88 
89     // @dev Converts an hexstring to bytes
90     function hexstrToBytes(string _hexstr) public pure returns (bytes) {
91         uint len = bytes(_hexstr).length;
92         require(len % 2 == 0);
93 
94         bytes memory bstr = bytes(new string(len / 2));
95         uint k = 0;
96         string memory s;
97         string memory r;
98         for (uint i = 0; i < len; i += 2) {
99             s = substring(_hexstr, i, i + 1);
100             r = substring(_hexstr, i + 1, i + 2);
101             uint p = parseInt16Char(s) * 16 + parseInt16Char(r);
102             bstr[k++] = uintToBytes32(p)[31];
103         }
104         return bstr;
105     }
106 
107     // @dev Parses a hexchar, like 'a', and returns its hex value, in this case 10
108     function parseInt16Char(string _char) public pure returns (uint) {
109         bytes memory bresult = bytes(_char);
110         // bool decimals = false;
111         if ((bresult[0] >= 48) && (bresult[0] <= 57)) {
112             return uint(bresult[0]) - 48;
113         } else if ((bresult[0] >= 65) && (bresult[0] <= 70)) {
114             return uint(bresult[0]) - 55;
115         } else if ((bresult[0] >= 97) && (bresult[0] <= 102)) {
116             return uint(bresult[0]) - 87;
117         } else {
118             revert();
119         }
120     }
121 
122     // @dev Converts a uint to a bytes32
123     // @thanks https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity
124     function uintToBytes32(uint _uint) public pure returns (bytes b) {
125         b = new bytes(32);
126         assembly {mstore(add(b, 32), _uint)}
127     }
128 
129     // @dev Hashes the signed message
130     // @ref https://github.com/ethereum/go-ethereum/issues/3731#issuecomment-293866868
131     function toEthereumSignedMessage(string _msg) public pure returns (bytes32) {
132         uint len = bytes(_msg).length;
133         require(len > 0);
134         bytes memory prefix = "\x19Ethereum Signed Message:\n";
135         return keccak256(abi.encodePacked(prefix, uintToString(len), _msg));
136     }
137 
138     // @dev Converts a uint in a string
139     function uintToString(uint _uint) public pure returns (string str) {
140         uint len = 0;
141         uint m = _uint + 0;
142         while (m != 0) {
143             len++;
144             m /= 10;
145         }
146         bytes memory b = new bytes(len);
147         uint i = len - 1;
148         while (_uint != 0) {
149             uint remainder = _uint % 10;
150             _uint = _uint / 10;
151             b[i--] = byte(48 + remainder);
152         }
153         str = string(b);
154     }
155 
156 
157     // @dev extract a substring
158     // @thanks https://ethereum.stackexchange.com/questions/31457/substring-in-solidity
159     function substring(string _str, uint _startIndex, uint _endIndex) public pure returns (string) {
160         bytes memory strBytes = bytes(_str);
161         require(_startIndex <= _endIndex);
162         require(_startIndex >= 0);
163         require(_endIndex <= strBytes.length);
164 
165         bytes memory result = new bytes(_endIndex - _startIndex);
166         for (uint i = _startIndex; i < _endIndex; i++) {
167             result[i - _startIndex] = strBytes[i];
168         }
169         return string(result);
170     }
171 }
172 contract StandardToken is Token {
173 
174     function transfer(address _to, uint256 _value) public returns (bool success) {
175         //Default assumes totalSupply can't be over max (2^256 - 1).
176         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
177         //Replace the if with this one instead.
178         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
179         require(balances[msg.sender] >= _value);
180         balances[msg.sender] -= _value;
181         balances[_to] += _value;
182         emit Transfer(msg.sender, _to, _value);
183         return true;
184     }
185 
186     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
187         //same as above. Replace this line with the following if you want to protect against wrapping uints.
188         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
189         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
190         balances[_to] += _value;
191         balances[_from] -= _value;
192         allowed[_from][msg.sender] -= _value;
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     function balanceOf(address _owner) public constant returns (uint256 balance) {
198         return balances[_owner];
199     }
200 
201     function approve(address _spender, uint256 _value) public returns (bool success) {
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
208       return allowed[_owner][_spender];
209     }
210 
211     mapping (address => uint256) balances;
212     mapping (address => mapping (address => uint256)) allowed;
213 }
214 
215 contract HumanStandardToken is StandardToken {
216 
217     /* Public variables of the token */
218 
219     /*
220     NOTE:
221     The following variables are OPTIONAL vanities. One does not have to include them.
222     They allow one to customise the token contract & in no way influences the core functionality.
223     Some wallets/interfaces might not even bother to look at this information.
224     */
225     string public name;                   //fancy name: eg Simon Bucks
226     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
227     string public symbol;                 //An identifier: eg SBX
228     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
229 
230     constructor(
231         uint256 _initialAmount,
232         string _tokenName,
233         uint8 _decimalUnits,
234         string _tokenSymbol
235         ) public {
236         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
237         totalSupply = _initialAmount;                        // Update total supply
238         name = _tokenName;                                   // Set the name for display purposes
239         decimals = _decimalUnits;                            // Amount of decimals for display purposes
240         symbol = _tokenSymbol;                               // Set the symbol for display purposes
241     }
242 
243     /* Approves and then calls the receiving contract */
244     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247 
248         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
249         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
250         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
251         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
252         return true;
253     }
254 }
255 
256 contract LedgerChannel {
257 
258     string public constant NAME = "Ledger Channel";
259     string public constant VERSION = "0.0.1";
260 
261     uint256 public numChannels = 0;
262 
263     event DidLCOpen (
264         bytes32 indexed channelId,
265         address indexed partyA,
266         address indexed partyI,
267         uint256 ethBalanceA,
268         address token,
269         uint256 tokenBalanceA,
270         uint256 LCopenTimeout
271     );
272 
273     event DidLCJoin (
274         bytes32 indexed channelId,
275         uint256 ethBalanceI,
276         uint256 tokenBalanceI
277     );
278 
279     event DidLCDeposit (
280         bytes32 indexed channelId,
281         address indexed recipient,
282         uint256 deposit,
283         bool isToken
284     );
285 
286     event DidLCUpdateState (
287         bytes32 indexed channelId, 
288         uint256 sequence, 
289         uint256 numOpenVc, 
290         uint256 ethBalanceA,
291         uint256 tokenBalanceA,
292         uint256 ethBalanceI,
293         uint256 tokenBalanceI,
294         bytes32 vcRoot,
295         uint256 updateLCtimeout
296     );
297 
298     event DidLCClose (
299         bytes32 indexed channelId,
300         uint256 sequence,
301         uint256 ethBalanceA,
302         uint256 tokenBalanceA,
303         uint256 ethBalanceI,
304         uint256 tokenBalanceI
305     );
306 
307     event DidVCInit (
308         bytes32 indexed lcId, 
309         bytes32 indexed vcId, 
310         bytes proof, 
311         uint256 sequence, 
312         address partyA, 
313         address partyB, 
314         uint256 balanceA, 
315         uint256 balanceB 
316     );
317 
318     event DidVCSettle (
319         bytes32 indexed lcId, 
320         bytes32 indexed vcId,
321         uint256 updateSeq, 
322         uint256 updateBalA, 
323         uint256 updateBalB,
324         address challenger,
325         uint256 updateVCtimeout
326     );
327 
328     event DidVCClose(
329         bytes32 indexed lcId, 
330         bytes32 indexed vcId, 
331         uint256 balanceA, 
332         uint256 balanceB
333     );
334 
335     struct Channel {
336         //TODO: figure out if it's better just to split arrays by balances/deposits instead of eth/erc20
337         address[2] partyAddresses; // 0: partyA 1: partyI
338         uint256[4] ethBalances; // 0: balanceA 1:balanceI 2:depositedA 3:depositedI
339         uint256[4] erc20Balances; // 0: balanceA 1:balanceI 2:depositedA 3:depositedI
340         uint256[2] initialDeposit; // 0: eth 1: tokens
341         uint256 sequence;
342         uint256 confirmTime;
343         bytes32 VCrootHash;
344         uint256 LCopenTimeout;
345         uint256 updateLCtimeout; // when update LC times out
346         bool isOpen; // true when both parties have joined
347         bool isUpdateLCSettling;
348         uint256 numOpenVC;
349         HumanStandardToken token;
350     }
351 
352     // virtual-channel state
353     struct VirtualChannel {
354         bool isClose;
355         bool isInSettlementState;
356         uint256 sequence;
357         address challenger; // Initiator of challenge
358         uint256 updateVCtimeout; // when update VC times out
359         // channel state
360         address partyA; // VC participant A
361         address partyB; // VC participant B
362         address partyI; // LC hub
363         uint256[2] ethBalances;
364         uint256[2] erc20Balances;
365         uint256[2] bond;
366         HumanStandardToken token;
367     }
368 
369     mapping(bytes32 => VirtualChannel) public virtualChannels;
370     mapping(bytes32 => Channel) public Channels;
371 
372     function createChannel(
373         bytes32 _lcID,
374         address _partyI,
375         uint256 _confirmTime,
376         address _token,
377         uint256[2] _balances // [eth, token]
378     ) 
379         public
380         payable 
381     {
382         require(Channels[_lcID].partyAddresses[0] == address(0), "Channel has already been created.");
383         require(_partyI != 0x0, "No partyI address provided to LC creation");
384         require(_balances[0] >= 0 && _balances[1] >= 0, "Balances cannot be negative");
385         // Set initial ledger channel state
386         // Alice must execute this and we assume the initial state 
387         // to be signed from this requirement
388         // Alternative is to check a sig as in joinChannel
389         Channels[_lcID].partyAddresses[0] = msg.sender;
390         Channels[_lcID].partyAddresses[1] = _partyI;
391 
392         if(_balances[0] != 0) {
393             require(msg.value == _balances[0], "Eth balance does not match sent value");
394             Channels[_lcID].ethBalances[0] = msg.value;
395         } 
396         if(_balances[1] != 0) {
397             Channels[_lcID].token = HumanStandardToken(_token);
398             require(Channels[_lcID].token.transferFrom(msg.sender, this, _balances[1]),"CreateChannel: token transfer failure");
399             Channels[_lcID].erc20Balances[0] = _balances[1];
400         }
401 
402         Channels[_lcID].sequence = 0;
403         Channels[_lcID].confirmTime = _confirmTime;
404         // is close flag, lc state sequence, number open vc, vc root hash, partyA... 
405         //Channels[_lcID].stateHash = keccak256(uint256(0), uint256(0), uint256(0), bytes32(0x0), bytes32(msg.sender), bytes32(_partyI), balanceA, balanceI);
406         Channels[_lcID].LCopenTimeout = now + _confirmTime;
407         Channels[_lcID].initialDeposit = _balances;
408 
409         emit DidLCOpen(_lcID, msg.sender, _partyI, _balances[0], _token, _balances[1], Channels[_lcID].LCopenTimeout);
410     }
411 
412     function LCOpenTimeout(bytes32 _lcID) public {
413         require(msg.sender == Channels[_lcID].partyAddresses[0] && Channels[_lcID].isOpen == false);
414         require(now > Channels[_lcID].LCopenTimeout);
415 
416         if(Channels[_lcID].initialDeposit[0] != 0) {
417             Channels[_lcID].partyAddresses[0].transfer(Channels[_lcID].ethBalances[0]);
418         } 
419         if(Channels[_lcID].initialDeposit[1] != 0) {
420             require(Channels[_lcID].token.transfer(Channels[_lcID].partyAddresses[0], Channels[_lcID].erc20Balances[0]),"CreateChannel: token transfer failure");
421         }
422 
423         emit DidLCClose(_lcID, 0, Channels[_lcID].ethBalances[0], Channels[_lcID].erc20Balances[0], 0, 0);
424 
425         // only safe to delete since no action was taken on this channel
426         delete Channels[_lcID];
427     }
428 
429     function joinChannel(bytes32 _lcID, uint256[2] _balances) public payable {
430         // require the channel is not open yet
431         require(Channels[_lcID].isOpen == false);
432         require(msg.sender == Channels[_lcID].partyAddresses[1]);
433 
434         if(_balances[0] != 0) {
435             require(msg.value == _balances[0], "state balance does not match sent value");
436             Channels[_lcID].ethBalances[1] = msg.value;
437         } 
438         if(_balances[1] != 0) {
439             require(Channels[_lcID].token.transferFrom(msg.sender, this, _balances[1]),"joinChannel: token transfer failure");
440             Channels[_lcID].erc20Balances[1] = _balances[1];          
441         }
442 
443         Channels[_lcID].initialDeposit[0]+=_balances[0];
444         Channels[_lcID].initialDeposit[1]+=_balances[1];
445         // no longer allow joining functions to be called
446         Channels[_lcID].isOpen = true;
447         numChannels++;
448 
449         emit DidLCJoin(_lcID, _balances[0], _balances[1]);
450     }
451 
452 
453     // additive updates of monetary state
454     // TODO check this for attack vectors
455     function deposit(bytes32 _lcID, address recipient, uint256 _balance, bool isToken) public payable {
456         require(Channels[_lcID].isOpen == true, "Tried adding funds to a closed channel");
457         require(recipient == Channels[_lcID].partyAddresses[0] || recipient == Channels[_lcID].partyAddresses[1]);
458 
459         //if(Channels[_lcID].token)
460 
461         if (Channels[_lcID].partyAddresses[0] == recipient) {
462             if(isToken) {
463                 require(Channels[_lcID].token.transferFrom(msg.sender, this, _balance),"deposit: token transfer failure");
464                 Channels[_lcID].erc20Balances[2] += _balance;
465             } else {
466                 require(msg.value == _balance, "state balance does not match sent value");
467                 Channels[_lcID].ethBalances[2] += msg.value;
468             }
469         }
470 
471         if (Channels[_lcID].partyAddresses[1] == recipient) {
472             if(isToken) {
473                 require(Channels[_lcID].token.transferFrom(msg.sender, this, _balance),"deposit: token transfer failure");
474                 Channels[_lcID].erc20Balances[3] += _balance;
475             } else {
476                 require(msg.value == _balance, "state balance does not match sent value");
477                 Channels[_lcID].ethBalances[3] += msg.value; 
478             }
479         }
480         
481         emit DidLCDeposit(_lcID, recipient, _balance, isToken);
482     }
483 
484     // TODO: Check there are no open virtual channels, the client should have cought this before signing a close LC state update
485     function consensusCloseChannel(
486         bytes32 _lcID, 
487         uint256 _sequence, 
488         uint256[4] _balances, // 0: ethBalanceA 1:ethBalanceI 2:tokenBalanceA 3:tokenBalanceI
489         string _sigA, 
490         string _sigI
491     ) 
492         public 
493     {
494         // assume num open vc is 0 and root hash is 0x0
495         //require(Channels[_lcID].sequence < _sequence);
496         require(Channels[_lcID].isOpen == true);
497         uint256 totalEthDeposit = Channels[_lcID].initialDeposit[0] + Channels[_lcID].ethBalances[2] + Channels[_lcID].ethBalances[3];
498         uint256 totalTokenDeposit = Channels[_lcID].initialDeposit[1] + Channels[_lcID].erc20Balances[2] + Channels[_lcID].erc20Balances[3];
499         require(totalEthDeposit == _balances[0] + _balances[1]);
500         require(totalTokenDeposit == _balances[2] + _balances[3]);
501 
502         bytes32 _state = keccak256(
503             abi.encodePacked(
504                 _lcID,
505                 true,
506                 _sequence,
507                 uint256(0),
508                 bytes32(0x0),
509                 Channels[_lcID].partyAddresses[0], 
510                 Channels[_lcID].partyAddresses[1], 
511                 _balances[0], 
512                 _balances[1],
513                 _balances[2],
514                 _balances[3]
515             )
516         );
517 
518         require(Channels[_lcID].partyAddresses[0] == ECTools.recoverSigner(_state, _sigA));
519         require(Channels[_lcID].partyAddresses[1] == ECTools.recoverSigner(_state, _sigI));
520 
521         Channels[_lcID].isOpen = false;
522 
523         if(_balances[0] != 0 || _balances[1] != 0) {
524             Channels[_lcID].partyAddresses[0].transfer(_balances[0]);
525             Channels[_lcID].partyAddresses[1].transfer(_balances[1]);
526         }
527 
528         if(_balances[2] != 0 || _balances[3] != 0) {
529             require(Channels[_lcID].token.transfer(Channels[_lcID].partyAddresses[0], _balances[2]),"happyCloseChannel: token transfer failure");
530             require(Channels[_lcID].token.transfer(Channels[_lcID].partyAddresses[1], _balances[3]),"happyCloseChannel: token transfer failure");          
531         }
532 
533         numChannels--;
534 
535         emit DidLCClose(_lcID, _sequence, _balances[0], _balances[1], _balances[2], _balances[3]);
536     }
537 
538     // Byzantine functions
539 
540     function updateLCstate(
541         bytes32 _lcID, 
542         uint256[6] updateParams, // [sequence, numOpenVc, ethbalanceA, ethbalanceI, tokenbalanceA, tokenbalanceI]
543         bytes32 _VCroot, 
544         string _sigA, 
545         string _sigI
546     ) 
547         public 
548     {
549         Channel storage channel = Channels[_lcID];
550         require(channel.isOpen);
551         require(channel.sequence < updateParams[0]); // do same as vc sequence check
552         require(channel.ethBalances[0] + channel.ethBalances[1] >= updateParams[2] + updateParams[3]);
553         require(channel.erc20Balances[0] + channel.erc20Balances[1] >= updateParams[4] + updateParams[5]);
554 
555         if(channel.isUpdateLCSettling == true) { 
556             require(channel.updateLCtimeout > now);
557         }
558       
559         bytes32 _state = keccak256(
560             abi.encodePacked(
561                 _lcID,
562                 false, 
563                 updateParams[0], 
564                 updateParams[1], 
565                 _VCroot, 
566                 channel.partyAddresses[0], 
567                 channel.partyAddresses[1], 
568                 updateParams[2], 
569                 updateParams[3],
570                 updateParams[4], 
571                 updateParams[5]
572             )
573         );
574 
575         require(channel.partyAddresses[0] == ECTools.recoverSigner(_state, _sigA));
576         require(channel.partyAddresses[1] == ECTools.recoverSigner(_state, _sigI));
577 
578         // update LC state
579         channel.sequence = updateParams[0];
580         channel.numOpenVC = updateParams[1];
581         channel.ethBalances[0] = updateParams[2];
582         channel.ethBalances[1] = updateParams[3];
583         channel.erc20Balances[0] = updateParams[4];
584         channel.erc20Balances[1] = updateParams[5];
585         channel.VCrootHash = _VCroot;
586         channel.isUpdateLCSettling = true;
587         channel.updateLCtimeout = now + channel.confirmTime;
588 
589         // make settlement flag
590 
591         emit DidLCUpdateState (
592             _lcID, 
593             updateParams[0], 
594             updateParams[1], 
595             updateParams[2], 
596             updateParams[3],
597             updateParams[4],
598             updateParams[5], 
599             _VCroot,
600             channel.updateLCtimeout
601         );
602     }
603 
604     // supply initial state of VC to "prime" the force push game  
605     function initVCstate(
606         bytes32 _lcID, 
607         bytes32 _vcID, 
608         bytes _proof, 
609         address _partyA, 
610         address _partyB, 
611         uint256[2] _bond,
612         uint256[4] _balances, // 0: ethBalanceA 1:ethBalanceI 2:tokenBalanceA 3:tokenBalanceI
613         string sigA
614     ) 
615         public 
616     {
617         require(Channels[_lcID].isOpen, "LC is closed.");
618         // sub-channel must be open
619         require(!virtualChannels[_vcID].isClose, "VC is closed.");
620         // Check time has passed on updateLCtimeout and has not passed the time to store a vc state
621         require(Channels[_lcID].updateLCtimeout < now, "LC timeout not over.");
622         // prevent rentry of initializing vc state
623         require(virtualChannels[_vcID].updateVCtimeout == 0);
624         // partyB is now Ingrid
625         bytes32 _initState = keccak256(
626             abi.encodePacked(_vcID, uint256(0), _partyA, _partyB, _bond[0], _bond[1], _balances[0], _balances[1], _balances[2], _balances[3])
627         );
628 
629         // Make sure Alice has signed initial vc state (A/B in oldState)
630         require(_partyA == ECTools.recoverSigner(_initState, sigA));
631 
632         // Check the oldState is in the root hash
633         require(_isContained(_initState, _proof, Channels[_lcID].VCrootHash) == true);
634 
635         virtualChannels[_vcID].partyA = _partyA; // VC participant A
636         virtualChannels[_vcID].partyB = _partyB; // VC participant B
637         virtualChannels[_vcID].sequence = uint256(0);
638         virtualChannels[_vcID].ethBalances[0] = _balances[0];
639         virtualChannels[_vcID].ethBalances[1] = _balances[1];
640         virtualChannels[_vcID].erc20Balances[0] = _balances[2];
641         virtualChannels[_vcID].erc20Balances[1] = _balances[3];
642         virtualChannels[_vcID].bond = _bond;
643         virtualChannels[_vcID].updateVCtimeout = now + Channels[_lcID].confirmTime;
644         virtualChannels[_vcID].isInSettlementState = true;
645 
646         emit DidVCInit(_lcID, _vcID, _proof, uint256(0), _partyA, _partyB, _balances[0], _balances[1]);
647     }
648 
649     //TODO: verify state transition since the hub did not agree to this state
650     // make sure the A/B balances are not beyond ingrids bonds  
651     // Params: vc init state, vc final balance, vcID
652     function settleVC(
653         bytes32 _lcID, 
654         bytes32 _vcID, 
655         uint256 updateSeq, 
656         address _partyA, 
657         address _partyB,
658         uint256[4] updateBal, // [ethupdateBalA, ethupdateBalB, tokenupdateBalA, tokenupdateBalB]
659         string sigA
660     ) 
661         public 
662     {
663         require(Channels[_lcID].isOpen, "LC is closed.");
664         // sub-channel must be open
665         require(!virtualChannels[_vcID].isClose, "VC is closed.");
666         require(virtualChannels[_vcID].sequence < updateSeq, "VC sequence is higher than update sequence.");
667         require(
668             virtualChannels[_vcID].ethBalances[1] < updateBal[1] && virtualChannels[_vcID].erc20Balances[1] < updateBal[3],
669             "State updates may only increase recipient balance."
670         );
671         require(
672             virtualChannels[_vcID].bond[0] == updateBal[0] + updateBal[1] &&
673             virtualChannels[_vcID].bond[1] == updateBal[2] + updateBal[3], 
674             "Incorrect balances for bonded amount");
675         // Check time has passed on updateLCtimeout and has not passed the time to store a vc state
676         // virtualChannels[_vcID].updateVCtimeout should be 0 on uninitialized vc state, and this should
677         // fail if initVC() isn't called first
678         // require(Channels[_lcID].updateLCtimeout < now && now < virtualChannels[_vcID].updateVCtimeout);
679         require(Channels[_lcID].updateLCtimeout < now); // for testing!
680 
681         bytes32 _updateState = keccak256(
682             abi.encodePacked(
683                 _vcID, 
684                 updateSeq, 
685                 _partyA, 
686                 _partyB, 
687                 virtualChannels[_vcID].bond[0], 
688                 virtualChannels[_vcID].bond[1], 
689                 updateBal[0], 
690                 updateBal[1], 
691                 updateBal[2], 
692                 updateBal[3]
693             )
694         );
695 
696         // Make sure Alice has signed a higher sequence new state
697         require(virtualChannels[_vcID].partyA == ECTools.recoverSigner(_updateState, sigA));
698 
699         // store VC data
700         // we may want to record who is initiating on-chain settles
701         virtualChannels[_vcID].challenger = msg.sender;
702         virtualChannels[_vcID].sequence = updateSeq;
703 
704         // channel state
705         virtualChannels[_vcID].ethBalances[0] = updateBal[0];
706         virtualChannels[_vcID].ethBalances[1] = updateBal[1];
707         virtualChannels[_vcID].erc20Balances[0] = updateBal[2];
708         virtualChannels[_vcID].erc20Balances[1] = updateBal[3];
709 
710         virtualChannels[_vcID].updateVCtimeout = now + Channels[_lcID].confirmTime;
711 
712         emit DidVCSettle(_lcID, _vcID, updateSeq, updateBal[0], updateBal[1], msg.sender, virtualChannels[_vcID].updateVCtimeout);
713     }
714 
715     function closeVirtualChannel(bytes32 _lcID, bytes32 _vcID) public {
716         // require(updateLCtimeout > now)
717         require(Channels[_lcID].isOpen, "LC is closed.");
718         require(virtualChannels[_vcID].isInSettlementState, "VC is not in settlement state.");
719         require(virtualChannels[_vcID].updateVCtimeout < now, "Update vc timeout has not elapsed.");
720         require(!virtualChannels[_vcID].isClose, "VC is already closed");
721         // reduce the number of open virtual channels stored on LC
722         Channels[_lcID].numOpenVC--;
723         // close vc flags
724         virtualChannels[_vcID].isClose = true;
725         // re-introduce the balances back into the LC state from the settled VC
726         // decide if this lc is alice or bob in the vc
727         if(virtualChannels[_vcID].partyA == Channels[_lcID].partyAddresses[0]) {
728             Channels[_lcID].ethBalances[0] += virtualChannels[_vcID].ethBalances[0];
729             Channels[_lcID].ethBalances[1] += virtualChannels[_vcID].ethBalances[1];
730 
731             Channels[_lcID].erc20Balances[0] += virtualChannels[_vcID].erc20Balances[0];
732             Channels[_lcID].erc20Balances[1] += virtualChannels[_vcID].erc20Balances[1];
733         } else if (virtualChannels[_vcID].partyB == Channels[_lcID].partyAddresses[0]) {
734             Channels[_lcID].ethBalances[0] += virtualChannels[_vcID].ethBalances[1];
735             Channels[_lcID].ethBalances[1] += virtualChannels[_vcID].ethBalances[0];
736 
737             Channels[_lcID].erc20Balances[0] += virtualChannels[_vcID].erc20Balances[1];
738             Channels[_lcID].erc20Balances[1] += virtualChannels[_vcID].erc20Balances[0];
739         }
740 
741         emit DidVCClose(_lcID, _vcID, virtualChannels[_vcID].erc20Balances[0], virtualChannels[_vcID].erc20Balances[1]);
742     }
743 
744 
745     // todo: allow ethier lc.end-user to nullify the settled LC state and return to off-chain
746     function byzantineCloseChannel(bytes32 _lcID) public {
747         Channel storage channel = Channels[_lcID];
748 
749         // check settlement flag
750         require(channel.isOpen, "Channel is not open");
751         require(channel.isUpdateLCSettling == true);
752         require(channel.numOpenVC == 0);
753         require(channel.updateLCtimeout < now, "LC timeout over.");
754 
755         // if off chain state update didnt reblance deposits, just return to deposit owner
756         uint256 totalEthDeposit = channel.initialDeposit[0] + channel.ethBalances[2] + channel.ethBalances[3];
757         uint256 totalTokenDeposit = channel.initialDeposit[1] + channel.erc20Balances[2] + channel.erc20Balances[3];
758 
759         uint256 possibleTotalEthBeforeDeposit = channel.ethBalances[0] + channel.ethBalances[1]; 
760         uint256 possibleTotalTokenBeforeDeposit = channel.erc20Balances[0] + channel.erc20Balances[1];
761 
762         if(possibleTotalEthBeforeDeposit < totalEthDeposit) {
763             channel.ethBalances[0]+=channel.ethBalances[2];
764             channel.ethBalances[1]+=channel.ethBalances[3];
765         } else {
766             require(possibleTotalEthBeforeDeposit == totalEthDeposit);
767         }
768 
769         if(possibleTotalTokenBeforeDeposit < totalTokenDeposit) {
770             channel.erc20Balances[0]+=channel.erc20Balances[2];
771             channel.erc20Balances[1]+=channel.erc20Balances[3];
772         } else {
773             require(possibleTotalTokenBeforeDeposit == totalTokenDeposit);
774         }
775 
776         // reentrancy
777         uint256 ethbalanceA = channel.ethBalances[0];
778         uint256 ethbalanceI = channel.ethBalances[1];
779         uint256 tokenbalanceA = channel.erc20Balances[0];
780         uint256 tokenbalanceI = channel.erc20Balances[1];
781 
782         channel.ethBalances[0] = 0;
783         channel.ethBalances[1] = 0;
784         channel.erc20Balances[0] = 0;
785         channel.erc20Balances[1] = 0;
786 
787         if(ethbalanceA != 0 || ethbalanceI != 0) {
788             channel.partyAddresses[0].transfer(ethbalanceA);
789             channel.partyAddresses[1].transfer(ethbalanceI);
790         }
791 
792         if(tokenbalanceA != 0 || tokenbalanceI != 0) {
793             require(
794                 channel.token.transfer(channel.partyAddresses[0], tokenbalanceA),
795                 "byzantineCloseChannel: token transfer failure"
796             );
797             require(
798                 channel.token.transfer(channel.partyAddresses[1], tokenbalanceI),
799                 "byzantineCloseChannel: token transfer failure"
800             );          
801         }
802 
803         channel.isOpen = false;
804         numChannels--;
805 
806         emit DidLCClose(_lcID, channel.sequence, ethbalanceA, ethbalanceI, tokenbalanceA, tokenbalanceI);
807     }
808 
809     function _isContained(bytes32 _hash, bytes _proof, bytes32 _root) internal pure returns (bool) {
810         bytes32 cursor = _hash;
811         bytes32 proofElem;
812 
813         for (uint256 i = 64; i <= _proof.length; i += 32) {
814             assembly { proofElem := mload(add(_proof, i)) }
815 
816             if (cursor < proofElem) {
817                 cursor = keccak256(abi.encodePacked(cursor, proofElem));
818             } else {
819                 cursor = keccak256(abi.encodePacked(proofElem, cursor));
820             }
821         }
822 
823         return cursor == _root;
824     }
825 
826     //Struct Getters
827     function getChannel(bytes32 id) public view returns (
828         address[2],
829         uint256[4],
830         uint256[4],
831         uint256[2],
832         uint256,
833         uint256,
834         bytes32,
835         uint256,
836         uint256,
837         bool,
838         bool,
839         uint256
840     ) {
841         Channel memory channel = Channels[id];
842         return (
843             channel.partyAddresses,
844             channel.ethBalances,
845             channel.erc20Balances,
846             channel.initialDeposit,
847             channel.sequence,
848             channel.confirmTime,
849             channel.VCrootHash,
850             channel.LCopenTimeout,
851             channel.updateLCtimeout,
852             channel.isOpen,
853             channel.isUpdateLCSettling,
854             channel.numOpenVC
855         );
856     }
857 
858     function getVirtualChannel(bytes32 id) public view returns(
859         bool,
860         bool,
861         uint256,
862         address,
863         uint256,
864         address,
865         address,
866         address,
867         uint256[2],
868         uint256[2],
869         uint256[2]
870     ) {
871         VirtualChannel memory virtualChannel = virtualChannels[id];
872         return(
873             virtualChannel.isClose,
874             virtualChannel.isInSettlementState,
875             virtualChannel.sequence,
876             virtualChannel.challenger,
877             virtualChannel.updateVCtimeout,
878             virtualChannel.partyA,
879             virtualChannel.partyB,
880             virtualChannel.partyI,
881             virtualChannel.ethBalances,
882             virtualChannel.erc20Balances,
883             virtualChannel.bond
884         );
885     }
886 }