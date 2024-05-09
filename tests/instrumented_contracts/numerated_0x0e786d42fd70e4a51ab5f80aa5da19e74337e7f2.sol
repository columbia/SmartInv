1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() internal {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 contract tokenInterface {
72 	function balanceOf(address _owner) public constant returns (uint256 balance);
73 	function transfer(address _to, uint256 _value) public returns (bool);
74 }
75 
76 contract Library {
77     // Notes:
78     // - this is limited to a payload length of 253 bytes
79     // - the payload should be ASCII as many clients will want to display this to the user
80     function createBSMHash(string payload) pure internal returns (bytes32) {
81         // \x18Bitcoin Signed Message:\n#{message.size.chr}#{message}
82         string memory prefix = "\x18Bitcoin Signed Message:\n";
83         return sha256(sha256(prefix, bytes1(bytes(payload).length), payload));
84     }
85 
86     function validateBSM(string payload, address key, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
87         return key == ecrecover(createBSMHash(payload), v, r, s);
88     }
89   
90 	//bytes32 constant mask4 = 0xffffffff00000000000000000000000000000000000000000000000000000000;
91 	//bytes1 constant network = 0x00;
92 
93     /*
94 	function getBitcoinAddress( bytes32 _xPoint, bytes32 _yPoint ) constant public returns( bytes20 hashedPubKey, bytes4 checkSum, bytes1 network)	{
95 		hashedPubKey 	= getHashedPublicKey(_xPoint, _yPoint);
96  		checkSum 	= getCheckSum(hashedPubKey);
97  		network 	= network;
98 	}*/
99 
100 	function btcAddrPubKeyUncompr( bytes32 _xPoint, bytes32 _yPoint) internal pure returns( bytes20 hashedPubKey )	{
101 		bytes1 startingByte = 0x04;
102  		return ripemd160(sha256(startingByte, _xPoint, _yPoint));
103 	}
104 	
105 	function btcAddrPubKeyCompr(bytes32 _x, bytes32 _y) internal pure returns( bytes20 hashedPubKey )	{
106 	    bytes1 _startingByte;
107 	    if (uint256(_y) % 2 == 0  ) {
108             _startingByte = 0x02;
109         } else {
110             _startingByte = 0x03;
111         }
112  		return ripemd160(sha256(_startingByte, _x));
113 	}
114 	
115 	function ethAddressPublicKey( bytes32 _xPoint, bytes32 _yPoint) internal pure returns( address ethAddr )	{
116  		return address(keccak256(_xPoint, _yPoint) ); 
117 	}
118 	/*
119 	function getCheckSum( bytes20 _hashedPubKey ) public pure returns(bytes4 checkSum) {
120 		var full = sha256((sha256(network, _hashedPubKey)));
121 		return bytes4(full&mask4);
122 	}
123     */
124     function toAsciiString(address x) internal pure returns (string) {
125         bytes memory s = new bytes(42);
126         s[0] = 0x30;
127         s[1] = 0x78;
128         for (uint i = 0; i < 20; i++) {
129             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
130             byte hi = byte(uint8(b) / 16);
131             byte lo = byte(uint8(b) - 16 * uint8(hi));
132             s[2+2*i] = char(hi);
133             s[2+2*i+1] = char(lo);            
134         }
135         return string(s);
136     }
137     
138     function char(byte b) internal pure returns (byte c) {
139         if (b < 10) return byte(uint8(b) + 0x30);
140         else return byte(uint8(b) + 0x57);
141     }
142     
143     /*
144     function getBTCAddr(bytes32 _xPoint, bytes32 _yPoint) pure public returns (bytes) {
145 		bytes20 hashedPubKey = btcAddressPublicKey(_xPoint, _yPoint);
146 		bytes4 checkSum = getCheckSum(hashedPubKey);
147 		bytes memory output = new bytes(25);
148 		
149 		output[0] = network[0];
150 		
151 		for (uint8 i = 0; i<20; i++) {
152             output[i+1] = hashedPubKey[i];
153         }
154         
155         for ( i = 0; i<4; i++) {
156             output[i+1+20] = checkSum[i];
157         }
158 
159         return output;
160     }
161     */
162 }
163 
164 contract Swap is Ownable, Library {
165     using SafeMath for uint256;
166     tokenInterface public tokenContract;
167 	Data public dataContract;
168     
169     mapping(address => bool) claimed;
170 
171     function Swap(address _tokenAddress) public {
172         tokenContract = tokenInterface(_tokenAddress);
173     }
174 
175     function claim(address _ethAddrReceiver, bytes32 _x, bytes32 _y, uint8 _v, bytes32 _r, bytes32 _s) public returns(bool) {
176         require ( dataContract != address(0) );
177         
178 		/* This code enable swap from BTC address compressed and uncompressed, check before compressed (more common format)
179 		 * and then also uncompressed address format - btc address is calculated in hex format without checksum and prefix
180 		 */
181         address btcAddr0x; 
182 		btcAddr0x = address( btcAddrPubKeyCompr(_x,_y) ); 
183 		if( dataContract.CftBalanceOf( btcAddr0x ) == 0 || claimed[ btcAddr0x ] ) { //check if have balance of if is already claimed
184 			btcAddr0x = address( btcAddrPubKeyUncompr(_x,_y) ); 
185 		}
186 		
187 		require ( dataContract.CftBalanceOf( btcAddr0x ) != 0 );
188         require ( !claimed[ btcAddr0x ] );
189 		
190 		address checkEthAddr0x = address( ethAddressPublicKey(_x,_y) ); //calculate eth address from pubkey for check of ecrecover function to verify sign
191         require ( validateBSM( toAsciiString(_ethAddrReceiver), checkEthAddr0x, _v, _r, _s) ); // check if eth address of receiver is signed by owner of privkey
192         
193         //add 10 number after the dot, 1 satoshi = 10^8 | 1 wei = 10^18
194         // the swap is 1:0,5
195         uint256 tokenAmount = dataContract.CftBalanceOf(btcAddr0x) * 10**10 / 2; 
196         
197         claimed[btcAddr0x] = true;
198         
199         tokenContract.transfer(_ethAddrReceiver, tokenAmount);
200         
201         return true;
202     }
203 
204     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
205         return tokenContract.transfer(to, value);
206     }
207     
208     function setTokenContract(address _tokenContract) public onlyOwner {
209         tokenContract = tokenInterface(_tokenContract);
210     }
211     
212     function setDataContract(address _tokenContract) public onlyOwner {
213         dataContract = Data(_tokenContract);
214     }
215 
216     function () public payable {
217         revert();
218     }
219 }
220 
221 
222 contract Data {
223     mapping(address => uint256) public CftBalanceOf;
224        function Data() public {
225             }
226 }