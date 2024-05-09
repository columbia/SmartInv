1 pragma solidity ^0.4.13;
2 
3 library MerkleProof {
4   /*
5    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
6    * and each pair of pre-images is sorted.
7    * @param _proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
8    * @param _root Merkle root
9    * @param _leaf Leaf of Merkle tree
10    */
11   function verifyProof(bytes _proof, bytes32 _root, bytes32 _leaf) public pure returns (bool) {
12     // Check if proof length is a multiple of 32
13     if (_proof.length % 32 != 0) return false;
14 
15     bytes32 proofElement;
16     bytes32 computedHash = _leaf;
17 
18     for (uint256 i = 32; i <= _proof.length; i += 32) {
19       assembly {
20         // Load the current element of the proof
21         proofElement := mload(add(_proof, i))
22       }
23 
24       if (computedHash < proofElement) {
25         // Hash(current computed hash + current element of the proof)
26         computedHash = keccak256(computedHash, proofElement);
27       } else {
28         // Hash(current element of the proof + current computed hash)
29         computedHash = keccak256(proofElement, computedHash);
30       }
31     }
32 
33     // Check if the computed hash (root) is equal to the provided root
34     return computedHash == _root;
35   }
36 }
37 
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     if (a == 0) {
41       return 0;
42     }
43     uint256 c = a * b;
44     assert(c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 contract ERC20Basic {
68   uint256 public totalSupply;
69   function balanceOf(address who) public view returns (uint256);
70   function transfer(address to, uint256 value) public returns (bool);
71   event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114 
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amount of tokens to be transferred
123    */
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    *
139    * Beware that changing an allowance with this method brings the risk that someone may use both the old
140    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifying the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) public view returns (uint256) {
159     return allowed[_owner][_spender];
160   }
161 
162   /**
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    */
168   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 contract BurnableToken is StandardToken {
188 
189     event Burn(address indexed burner, uint256 value);
190 
191     /**
192      * @dev Burns a specific amount of tokens.
193      * @param _value The amount of token to be burned.
194      */
195     function burn(uint256 _value) public {
196         require(_value > 0);
197         require(_value <= balances[msg.sender]);
198         // no need to require value <= totalSupply, since that would imply the
199         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
200 
201         address burner = msg.sender;
202         balances[burner] = balances[burner].sub(_value);
203         totalSupply = totalSupply.sub(_value);
204         Burn(burner, _value);
205     }
206 }
207 
208 contract DelayedReleaseToken is StandardToken {
209 
210     /* Temporary administrator address, only used for the initial token release, must be initialized by token constructor. */
211     address temporaryAdmin;
212 
213     /* Whether or not the delayed token release has occurred. */
214     bool hasBeenReleased = false;
215 
216     /* Number of tokens to be released, must be initialized by token constructor. */
217     uint numberOfDelayedTokens;
218 
219     /* Event for convenience. */
220     event TokensReleased(address destination, uint numberOfTokens);
221 
222     /**
223      * @dev Release the previously specified amount of tokens to the provided address
224      * @param destination Address for which tokens will be released (minted) 
225      */
226     function releaseTokens(address destination) public {
227         require((msg.sender == temporaryAdmin) && (!hasBeenReleased));
228         hasBeenReleased = true;
229         balances[destination] = numberOfDelayedTokens;
230         Transfer(address(0), destination, numberOfDelayedTokens); 
231         TokensReleased(destination, numberOfDelayedTokens);
232     }
233 
234 }
235 
236 contract UTXORedeemableToken is StandardToken {
237 
238     /* Root hash of the UTXO Merkle tree, must be initialized by token constructor. */
239     bytes32 public rootUTXOMerkleTreeHash;
240 
241     /* Redeemed UTXOs. */
242     mapping(bytes32 => bool) redeemedUTXOs;
243 
244     /* Multiplier - tokens per Satoshi, must be initialized by token constructor. */
245     uint public multiplier;
246 
247     /* Total tokens redeemed so far. */
248     uint public totalRedeemed = 0;
249 
250     /* Maximum redeemable tokens, must be initialized by token constructor. */
251     uint public maximumRedeemable;
252 
253     /* Redemption event, containing all relevant data for later analysis if desired. */
254     event UTXORedeemed(bytes32 txid, uint8 outputIndex, uint satoshis, bytes proof, bytes pubKey, uint8 v, bytes32 r, bytes32 s, address indexed redeemer, uint numberOfTokens);
255 
256     /**
257      * @dev Extract a bytes32 subarray from an arbitrary length bytes array.
258      * @param data Bytes array from which to extract the subarray
259      * @param pos Starting position from which to copy
260      * @return Extracted length 32 byte array
261      */
262     function extract(bytes data, uint pos) private pure returns (bytes32 result) { 
263         for (uint i = 0; i < 32; i++) {
264             result ^= (bytes32(0xff00000000000000000000000000000000000000000000000000000000000000) & data[i + pos]) >> (i * 8);
265         }
266         return result;
267     }
268     
269     /**
270      * @dev Validate that a provided ECSDA signature was signed by the specified address
271      * @param hash Hash of signed data
272      * @param v v parameter of ECDSA signature
273      * @param r r parameter of ECDSA signature
274      * @param s s parameter of ECDSA signature
275      * @param expected Address claiming to have created this signature
276      * @return Whether or not the signature was valid
277      */
278     function validateSignature (bytes32 hash, uint8 v, bytes32 r, bytes32 s, address expected) public pure returns (bool) {
279         return ecrecover(hash, v, r, s) == expected;
280     }
281 
282     /**
283      * @dev Validate that the hash of a provided address was signed by the ECDSA public key associated with the specified Ethereum address
284      * @param addr Address signed
285      * @param pubKey Uncompressed ECDSA public key claiming to have created this signature
286      * @param v v parameter of ECDSA signature
287      * @param r r parameter of ECDSA signature
288      * @param s s parameter of ECDSA signature
289      * @return Whether or not the signature was valid
290      */
291     function ecdsaVerify (address addr, bytes pubKey, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
292         return validateSignature(sha256(addr), v, r, s, pubKeyToEthereumAddress(pubKey));
293     }
294 
295     /**
296      * @dev Convert an uncompressed ECDSA public key into an Ethereum address
297      * @param pubKey Uncompressed ECDSA public key to convert
298      * @return Ethereum address generated from the ECDSA public key
299      */
300     function pubKeyToEthereumAddress (bytes pubKey) public pure returns (address) {
301         return address(uint(keccak256(pubKey)) & 0x000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
302     }
303 
304     /**
305      * @dev Calculate the Bitcoin-style address associated with an ECDSA public key
306      * @param pubKey ECDSA public key to convert
307      * @param isCompressed Whether or not the Bitcoin address was generated from a compressed key
308      * @return Raw Bitcoin address (no base58-check encoding)
309      */
310     function pubKeyToBitcoinAddress(bytes pubKey, bool isCompressed) public pure returns (bytes20) {
311         /* Helpful references:
312            - https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses 
313            - https://github.com/cryptocoinjs/ecurve/blob/master/lib/point.js
314         */
315 
316         /* x coordinate - first 32 bytes of public key */
317         uint x = uint(extract(pubKey, 0));
318         /* y coordinate - second 32 bytes of public key */
319         uint y = uint(extract(pubKey, 32)); 
320         uint8 startingByte;
321         if (isCompressed) {
322             /* Hash the compressed public key format. */
323             startingByte = y % 2 == 0 ? 0x02 : 0x03;
324             return ripemd160(sha256(startingByte, x));
325         } else {
326             /* Hash the uncompressed public key format. */
327             startingByte = 0x04;
328             return ripemd160(sha256(startingByte, x, y));
329         }
330     }
331 
332     /**
333      * @dev Verify a Merkle proof using the UTXO Merkle tree
334      * @param proof Generated Merkle tree proof
335      * @param merkleLeafHash Hash asserted to be present in the Merkle tree
336      * @return Whether or not the proof is valid
337      */
338     function verifyProof(bytes proof, bytes32 merkleLeafHash) public constant returns (bool) {
339         return MerkleProof.verifyProof(proof, rootUTXOMerkleTreeHash, merkleLeafHash);
340     }
341 
342     /**
343      * @dev Convenience helper function to check if a UTXO can be redeemed
344      * @param txid Transaction hash
345      * @param originalAddress Raw Bitcoin address (no base58-check encoding)
346      * @param outputIndex Output index of UTXO
347      * @param satoshis Amount of UTXO in satoshis
348      * @param proof Merkle tree proof
349      * @return Whether or not the UTXO can be redeemed
350      */
351     function canRedeemUTXO(bytes32 txid, bytes20 originalAddress, uint8 outputIndex, uint satoshis, bytes proof) public constant returns (bool) {
352         /* Calculate the hash of the Merkle leaf associated with this UTXO. */
353         bytes32 merkleLeafHash = keccak256(txid, originalAddress, outputIndex, satoshis);
354     
355         /* Verify the proof. */
356         return canRedeemUTXOHash(merkleLeafHash, proof);
357     }
358       
359     /**
360      * @dev Verify that a UTXO with the specified Merkle leaf hash can be redeemed
361      * @param merkleLeafHash Merkle tree hash of the UTXO to be checked
362      * @param proof Merkle tree proof
363      * @return Whether or not the UTXO with the specified hash can be redeemed
364      */
365     function canRedeemUTXOHash(bytes32 merkleLeafHash, bytes proof) public constant returns (bool) {
366         /* Check that the UTXO has not yet been redeemed and that it exists in the Merkle tree. */
367         return((redeemedUTXOs[merkleLeafHash] == false) && verifyProof(proof, merkleLeafHash));
368     }
369 
370     /**
371      * @dev Redeem a UTXO, crediting a proportional amount of tokens (if valid) to the sending address
372      * @param txid Transaction hash
373      * @param outputIndex Output index of the UTXO
374      * @param satoshis Amount of UTXO in satoshis
375      * @param proof Merkle tree proof
376      * @param pubKey Uncompressed ECDSA public key to which the UTXO was sent
377      * @param isCompressed Whether the Bitcoin address was generated from a compressed public key
378      * @param v v parameter of ECDSA signature
379      * @param r r parameter of ECDSA signature
380      * @param s s parameter of ECDSA signature
381      * @return The number of tokens redeemed, if successful
382      */
383     function redeemUTXO (bytes32 txid, uint8 outputIndex, uint satoshis, bytes proof, bytes pubKey, bool isCompressed, uint8 v, bytes32 r, bytes32 s) public returns (uint tokensRedeemed) {
384 
385         /* Calculate original Bitcoin-style address associated with the provided public key. */
386         bytes20 originalAddress = pubKeyToBitcoinAddress(pubKey, isCompressed);
387 
388         /* Calculate the UTXO Merkle leaf hash. */
389         bytes32 merkleLeafHash = keccak256(txid, originalAddress, outputIndex, satoshis);
390 
391         /* Verify that the UTXO can be redeemed. */
392         require(canRedeemUTXOHash(merkleLeafHash, proof));
393 
394         /* Claimant must sign the Ethereum address to which they wish to remit the redeemed tokens. */
395         require(ecdsaVerify(msg.sender, pubKey, v, r, s));
396 
397         /* Mark the UTXO as redeemed. */
398         redeemedUTXOs[merkleLeafHash] = true;
399 
400         /* Calculate the redeemed tokens. */
401         tokensRedeemed = SafeMath.mul(satoshis, multiplier);
402 
403         /* Track total redeemed tokens. */
404         totalRedeemed = SafeMath.add(totalRedeemed, tokensRedeemed);
405 
406         /* Sanity check. */
407         require(totalRedeemed <= maximumRedeemable);
408 
409         /* Credit the redeemer. */ 
410         balances[msg.sender] = SafeMath.add(balances[msg.sender], tokensRedeemed);
411 
412         /* Mark the transfer event. */
413         Transfer(address(0), msg.sender, tokensRedeemed);
414 
415         /* Mark the UTXO redemption event. */
416         UTXORedeemed(txid, outputIndex, satoshis, proof, pubKey, v, r, s, msg.sender, tokensRedeemed);
417         
418         /* Return the number of tokens redeemed. */
419         return tokensRedeemed;
420 
421     }
422 
423 }
424 
425 contract WyvernToken is DelayedReleaseToken, UTXORedeemableToken, BurnableToken {
426 
427     uint constant public decimals     = 18;
428     string constant public name       = "Project Wyvern Token";
429     string constant public symbol     = "WYV";
430 
431     /* Amount of tokens per Wyvern. */
432     uint constant public MULTIPLIER       = 1;
433 
434     /* Constant for conversion from satoshis to tokens. */
435     uint constant public SATS_TO_TOKENS   = MULTIPLIER * (10 ** decimals) / (10 ** 8);
436 
437     /* Total mint amount, in tokens (will be reached when all UTXOs are redeemed). */
438     uint constant public MINT_AMOUNT      = 2000000 * MULTIPLIER * (10 ** decimals);
439 
440     /**
441       * @dev Initialize the Wyvern token
442       * @param merkleRoot Merkle tree root of the UTXO set
443       * @param totalUtxoAmount Total satoshis of the UTXO set
444       */
445     function WyvernToken (bytes32 merkleRoot, uint totalUtxoAmount) public {
446         /* Total number of tokens that can be redeemed from UTXOs. */
447         uint utxoTokens = SATS_TO_TOKENS * totalUtxoAmount;
448 
449         /* Configure DelayedReleaseToken. */
450         temporaryAdmin = msg.sender;
451         numberOfDelayedTokens = MINT_AMOUNT - utxoTokens;
452 
453         /* Configure UTXORedeemableToken. */
454         rootUTXOMerkleTreeHash = merkleRoot;
455         totalSupply = MINT_AMOUNT;
456         maximumRedeemable = utxoTokens;
457         multiplier = SATS_TO_TOKENS;
458     }
459 
460 }