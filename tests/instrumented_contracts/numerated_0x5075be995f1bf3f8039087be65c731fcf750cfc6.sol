1 pragma solidity ^0.5.3;
2 
3 /**
4 * @author ESPAY PTY LTD.
5 */
6 
7 /**
8 * @title ERC223Interface
9 * @dev ERC223 Contract Interface
10 */
11 contract ERC20Interface {
12     function transfer(address _to, uint256 _value) public returns (bool);
13     function balanceOf(address who)public view returns (uint);
14 }
15 
16 /**
17 * @title Forwarder
18 * @dev Contract that will forward any incoming Ether & token to wallet
19 */
20 contract Forwarder {
21     
22     address payable public parentAddress;
23  
24     event ForwarderDeposited(address from, uint value, bytes data);
25     event TokensFlushed(address forwarderAddress, uint value, address tokenContractAddress);
26 
27     /**
28     * @dev Modifier that will execute internal code block only if the sender is the parent address
29     */
30     modifier onlyParent {
31         require(msg.sender == parentAddress);
32         _;
33     }
34     
35     /**
36     * @dev Create the contract, and sets the destination address to that of the creator
37     */
38     constructor() public{
39         parentAddress = msg.sender;
40     }
41 
42     /**
43     * @dev Default function; Gets called when Ether is deposited, and forwards it to the parent address.
44     *      Credit eth to contract creator.
45     */
46     function() external payable {
47         parentAddress.transfer(msg.value);
48         emit ForwarderDeposited(msg.sender, msg.value, msg.data);
49     }
50 
51     /**
52     * @dev Execute a token transfer of the full balance from the forwarder token to the parent address
53     * @param tokenContractAddress the address of the erc20 token contract
54     */
55     function flushTokens(address tokenContractAddress) public onlyParent {
56         ERC20Interface instance = ERC20Interface(tokenContractAddress);
57         uint forwarderBalance = instance.balanceOf(address(this));
58         require(forwarderBalance > 0);
59         require(instance.transfer(parentAddress, forwarderBalance));
60         emit TokensFlushed(address(this), forwarderBalance, tokenContractAddress);
61     }
62   
63     /**
64     * @dev Execute a specified token transfer from the forwarder token to the parent address.
65     * @param _from the address of the erc20 token contract.
66     * @param _value the amount of token.
67     */
68     function flushToken(address _from, uint _value) external{
69         require(ERC20Interface(_from).transfer(parentAddress, _value), "instance error");
70     }
71 
72     /**
73     * @dev It is possible that funds were sent to this address before the contract was deployed.
74     *      We can flush those funds to the parent address.
75     */
76     function flush() public {
77         parentAddress.transfer(address(this).balance);
78     }
79 }
80 
81 /**
82 * @title MultiSignWallet
83 */
84 contract MultiSignWallet {
85     
86     address[] public signers;
87     bool public safeMode; 
88     uint forwarderCount;
89     uint lastsequenceId;
90     
91     event Deposited(address from, uint value, bytes data);
92     event SafeModeActivated(address msgSender);
93     event SafeModeInActivated(address msgSender);
94     event ForwarderCreated(address forwarderAddress);
95     event Transacted(address msgSender, address otherSigner, bytes32 operation, address toAddress, uint value, bytes data);
96     event TokensTransfer(address tokenContractAddress, uint value);
97     
98     /**
99     * @dev Modifier that will execute internal code block only if the 
100     *      sender is an authorized signer on this wallet
101     */
102     modifier onlySigner {
103         require(isSigner(msg.sender));
104         _;
105     }
106 
107     /**
108     * @dev Set up a simple multi-sig wallet by specifying the signers allowed to be used on this wallet.
109     *      2 signers will be required to send a transaction from this wallet.
110     *      Note: The sender is NOT automatically added to the list of signers.
111     *      Signers CANNOT be changed once they are set
112     * @param allowedSigners An array of signers on the wallet
113     */
114     constructor(address[] memory allowedSigners) public {
115         require(allowedSigners.length == 3);
116         signers = allowedSigners;
117     }
118 
119     /**
120     * @dev Gets called when a transaction is received without calling a method
121     */
122     function() external payable {
123         if(msg.value > 0){
124             emit Deposited(msg.sender, msg.value, msg.data);
125         }
126     }
127     
128     /**
129     * @dev Determine if an address is a signer on this wallet
130     * @param signer address to check
131     * @return boolean indicating whether address is signer or not
132     */
133     function isSigner(address signer) public view returns (bool) {
134         for (uint i = 0; i < signers.length; i++) {
135             if (signers[i] == signer) {
136                 return true;
137             }
138         }
139         return false;
140     }
141 
142     /**
143     * @dev Irrevocably puts contract into safe mode. When in this mode, 
144     *      transactions may only be sent to signing addresses.
145     */
146     function activateSafeMode() public onlySigner {
147         require(!safeMode);
148         safeMode = true;
149         emit SafeModeActivated(msg.sender);
150     }
151     
152     /**
153     * @dev Irrevocably puts out contract into safe mode.
154     */ 
155     function turnOffSafeMode() public onlySigner {
156         require(safeMode);
157         safeMode = false;
158         emit SafeModeInActivated(msg.sender);
159     }
160     
161     /**
162     * @dev Create a new contract (and also address) that forwards funds to this contract
163     *      returns address of newly created forwarder address
164     */
165     function createForwarder() public returns (address) {
166         Forwarder f = new Forwarder();
167         forwarderCount += 1;
168         emit ForwarderCreated(address(f));
169         return(address(f));
170     }
171     
172     /**
173     * @dev for return No of forwarder generated. 
174     * @return total number of generated forwarder count.
175     */
176     function getForwarder() public view returns(uint){
177         return forwarderCount;
178     }
179     
180     /**
181     * @dev Execute a token flush from one of the forwarder addresses. 
182     *      This transfer needs only a single signature and can be done by any signer
183     * @param forwarderAddress the address of the forwarder address to flush the tokens from
184     * @param tokenContractAddress the address of the erc20 token contract
185     */
186     function flushForwarderTokens(address payable forwarderAddress, address tokenContractAddress) public onlySigner {
187         Forwarder forwarder = Forwarder(forwarderAddress);
188         forwarder.flushTokens(tokenContractAddress);
189     }
190     
191     /**
192     * @dev Gets the next available sequence ID for signing when using executeAndConfirm
193     * @return the sequenceId one higher than the highest currently stored
194     */
195     function getNextSequenceId() public view returns (uint) {
196         return lastsequenceId+1;
197     }
198     
199     /** 
200     * @dev generate the hash for sendMultiSig
201     *      same parameter as sendMultiSig
202     * @return the hash generated by parameters 
203     */
204     function getHash(address toAddress, uint value, bytes memory data, uint expireTime, uint sequenceId)public pure returns (bytes32){
205         return keccak256(abi.encodePacked("ETHER", toAddress, value, data, expireTime, sequenceId));
206     }
207 
208     /**
209     * @dev Execute a multi-signature transaction from this wallet using 2 signers: 
210     *      one from msg.sender and the other from ecrecover.
211     *      Sequence IDs are numbers starting from 1. They are used to prevent replay 
212     *      attacks and may not be repeated.
213     * @param toAddress the destination address to send an outgoing transaction
214     * @param value the amount in Wei to be sent
215     * @param data the data to send to the toAddress when invoking the transaction
216     * @param expireTime the number of seconds since 1970 for which this transaction is valid
217     * @param sequenceId the unique sequence id obtainable from getNextSequenceId
218     * @param signature see Data Formats
219     */
220     function sendMultiSig(address payable toAddress, uint value, bytes memory data, uint expireTime, uint sequenceId, bytes memory signature) public payable onlySigner {
221         bytes32 operationHash = keccak256(abi.encodePacked("ETHER", toAddress, value, data, expireTime, sequenceId));
222         address otherSigner = verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
223         toAddress.transfer(value);
224         emit Transacted(msg.sender, otherSigner, operationHash, toAddress, value, data);
225     }
226     
227     /** 
228     * @dev generate the hash for sendMultiSigToken and sendMultiSigForwarder.
229     *      same parameter as sendMultiSigToken and sendMultiSigForwarder.
230     * @return the hash generated by parameters 
231     */
232     function getTokenHash( address toAddress, uint value, address tokenContractAddress, uint expireTime, uint sequenceId) public pure returns (bytes32){
233         return keccak256(abi.encodePacked("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId));
234     }
235   
236     /**
237     * @dev Execute a multi-signature token transfer from this wallet using 2 signers: 
238     *      one from msg.sender and the other from ecrecover.
239     *      Sequence IDs are numbers starting from 1. They are used to prevent replay 
240     *      attacks and may not be repeated.
241     * @param toAddress the destination address to send an outgoing transaction
242     * @param value the amount in tokens to be sent
243     * @param tokenContractAddress the address of the erc20 token contract
244     * @param expireTime the number of seconds since 1970 for which this transaction is valid
245     * @param sequenceId the unique sequence id obtainable from getNextSequenceId
246     * @param signature see Data Formats
247     */
248     function sendMultiSigToken(address toAddress, uint value, address tokenContractAddress, uint expireTime, uint sequenceId, bytes memory signature) public onlySigner {
249         bytes32 operationHash = keccak256(abi.encodePacked("ERC20", toAddress, value, tokenContractAddress, expireTime, sequenceId));
250         verifyMultiSig(toAddress, operationHash, signature, expireTime, sequenceId);
251         ERC20Interface instance = ERC20Interface(tokenContractAddress);
252         require(instance.balanceOf(address(this)) > 0);
253         require(instance.transfer(toAddress, value));
254         emit TokensTransfer(tokenContractAddress, value);
255     }
256     
257     /**
258     * @dev Gets signer's address using ecrecover
259     * @param operationHash see Data Formats
260     * @param signature see Data Formats
261     * @return address recovered from the signature
262     */
263     function recoverAddressFromSignature(bytes32 operationHash, bytes memory signature) private pure returns (address) {
264         require(signature.length == 65);
265         bytes32 r;
266         bytes32 s;
267         uint8 v;
268         assembly {
269             r := mload(add(signature, 32))
270             s := mload(add(signature, 64))
271             v := byte(0, mload(add(signature, 96)))
272         }
273         if (v < 27) {
274             v += 27; 
275         }
276         return ecrecover(operationHash, v, r, s);
277     }
278 
279     /**
280     * @dev Verify that the sequence id has not been used before and inserts it. Throws if the sequence ID was not accepted.
281     * @param sequenceId to insert into array of stored ids
282     */
283     function tryInsertSequenceId(uint sequenceId) private onlySigner {
284         require(sequenceId > lastsequenceId && sequenceId <= (lastsequenceId+1000), "Enter Valid sequenceId");
285         lastsequenceId=sequenceId;
286     }
287 
288     /** 
289     * @dev Do common multisig verification for both eth sends and erc20token transfers
290     * @param toAddress the destination address to send an outgoing transaction
291     * @param operationHash see Data Formats
292     * @param signature see Data Formats
293     * @param expireTime the number of seconds since 1970 for which this transaction is valid
294     * @param sequenceId the unique sequence id obtainable from getNextSequenceId
295     * @return address that has created the signature
296     */
297     function verifyMultiSig(address toAddress, bytes32 operationHash, bytes memory signature, uint expireTime, uint sequenceId) private returns (address) {
298 
299         address otherSigner = recoverAddressFromSignature(operationHash, signature);
300         if (safeMode && !isSigner(toAddress)) {
301             revert("safemode error");
302         }
303         require(isSigner(otherSigner) && expireTime > now);
304         require(otherSigner != msg.sender);
305         tryInsertSequenceId(sequenceId);
306         return otherSigner;
307     }
308 }