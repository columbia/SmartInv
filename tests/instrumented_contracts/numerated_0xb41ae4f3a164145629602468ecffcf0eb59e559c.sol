1 pragma solidity ^0.4.15;
2 
3 /**
4  * title Eliptic curve signature operations
5  *
6  * 
7  */
8 
9 library ECRecovery {
10 
11   /**
12    * Recover signer address from a message by using his signature
13    * param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
14    * param sig bytes signature, the signature is generated using web3.eth.sign()
15    */
16   function recover(bytes32 hash, bytes sig) constant returns (address) {
17     bytes32 r;
18     bytes32 s;
19     uint8 v;
20 
21     //Check the signature length
22     if (sig.length != 65) {
23       return (address(0));
24     }
25 
26     // Divide the signature in r, s and v variables
27     assembly {
28       r := mload(add(sig, 32))
29       s := mload(add(sig, 64))
30       v := byte(0, mload(add(sig, 96)))
31     }
32 
33     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
34     if (v < 27) {
35       v += 27;
36     }
37 
38     // If the version is correct return the signer address
39     if (v != 27 && v != 28) {
40       return (address(0));
41     } else {
42       /* prefix might be needed for geth only
43       * https://github.com/ethereum/go-ethereum/issues/3731
44       */
45       bytes memory prefix = "\x19Ethereum Signed Message:\n32";
46       hash = sha3(prefix, hash);
47       return ecrecover(hash, v, r, s);
48     }
49   }
50 
51 }
52 
53 /**
54  * title SafeMath
55  * Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal constant returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 /**
84  * title Ownable
85  * The Ownable contract has an owner address, and provides basic authorization control
86  * functions, this simplifies the implementation of "user permissions".
87  */
88 contract Ownable {
89   address public owner;
90 
91 
92   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94 
95   /**
96    * The Ownable constructor sets the original `owner` of the contract to the sender
97    * account.
98    */
99   function Ownable() {
100     owner = msg.sender;
101   }
102 
103 
104   /**
105    * Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112 
113   /**
114    * Allows the current owner to transfer control of the contract to a newOwner.
115    * param newOwner The address to transfer ownership to.
116    */
117   function transferOwnership(address newOwner) onlyOwner {
118     require(newOwner != address(0));      
119     OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 
123 }
124 
125 /**
126  * Контракт центральной логики
127  */
128 
129 contract MemeCore is Ownable {
130     using SafeMath for uint;
131     using ECRecovery for bytes32;
132 
133     /* Мапа адрес получателя - nonce, нужно для того, чтобы нельзя было повторно запросить withdraw */
134     mapping (address => uint) withdrawalsNonce;
135 
136     event Withdraw(address receiver, uint weiAmount);
137     event WithdrawCanceled(address receiver);
138 
139     function() payable {
140         require(msg.value != 0);
141     }
142 
143     /* Запрос на выплату от пользователя, используется в случае, если клиент делает withdraw */
144     function _withdraw(address toAddress, uint weiAmount) private {
145         // Делаем перевод получателю
146         toAddress.transfer(weiAmount);
147 
148         Withdraw(toAddress, weiAmount);
149     }
150 
151 
152     /* Запрос на выплату от пользователя, используется в случае, если клиент делает withdraw */
153     function withdraw(uint weiAmount, bytes signedData) external {
154         uint256 nonce = withdrawalsNonce[msg.sender] + 1;
155 
156         bytes32 validatingHash = keccak256(msg.sender, weiAmount, nonce);
157 
158         // Подписывать все транзакции должен owner
159         address addressRecovered = validatingHash.recover(signedData);
160 
161         require(addressRecovered == owner);
162 
163         // Делаем перевод получателю
164         _withdraw(msg.sender, weiAmount);
165 
166         withdrawalsNonce[msg.sender] = nonce;
167     }
168 
169     /* Отмена withdraw */
170     function cancelWithdraw(){
171         withdrawalsNonce[msg.sender]++;
172 
173         WithdrawCanceled(msg.sender);
174     }
175 
176     /* Доступна только owner'у, используется в случае, если бэкенд делает withdraw */
177     function backendWithdraw(address toAddress, uint weiAmount) external onlyOwner {
178         require(toAddress != 0);
179 
180         // Делаем перевод получателю
181         _withdraw(toAddress, weiAmount);
182     }
183 
184 }