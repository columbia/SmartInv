1 pragma solidity ^0.5.16;
2 
3 contract Ownable
4 {
5     address public owner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     constructor() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) public onlyOwner {
19         require(newOwner != address(0));
20         emit OwnershipTransferred(owner, newOwner);
21         owner = newOwner;
22     }
23 }
24 
25 contract TokenERC20 is Ownable {
26     bytes32 public standard;
27     bytes32 public name;
28     bytes32 public symbol;
29     uint256 public totalSupply;
30     uint8 public decimals;
31     bool public allowTransactions;
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34     function transfer(address _to, uint256 _value) public;
35     function approve(address _spender, uint256 _value) public;
36     function transferFrom(address _from, address _to, uint256 _value) public;
37 }
38 
39 library ECRecovery {
40 
41   /**
42    * @dev Recover signer address from a message by using his signature
43    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
44    * @param sig bytes signature, the signature is generated using web3.eth.sign()
45    */
46   function recover(bytes32 hash, bytes memory sig) internal pure returns (address) {
47     bytes32 r;
48     bytes32 s;
49     uint8 v;
50 
51     //Check the signature length
52     if (sig.length != 65) {
53       return (address(0));
54     }
55     
56     // Divide the signature in r, s and v variables
57     assembly {
58       r := mload(add(sig, 32))
59       s := mload(add(sig, 64))
60       v := byte(0, mload(add(sig, 96)))
61     }
62 
63     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
64     if (v < 27) {
65       v += 27;
66     }
67 
68     // If the version is correct return the signer address
69     if (v != 27 && v != 28) {
70       return (address(0));
71     } else {
72       return ecrecover(hash, v, r, s);
73     }
74   }
75 
76 }
77 
78 contract StmWalletSwap is Ownable {
79     using ECRecovery for bytes32;
80     
81     mapping(bytes32 => bool) public swapList;
82     
83     event Swap(address _recipient, bytes32 _tradeID, address _cFrom, address _cOut, uint256 _vFrom, uint256 _vOut);
84     event SwapAltChain(address _recipient, bytes32 _tradeID, address _cFrom, uint256 _vFrom);
85     event TransferAltChain(bytes32 _tradeID, address _to, address _token, uint256 _amount);
86     event AddEth(uint256 _amount);
87     
88    /**
89     * _tradeID   - swap ID
90     * _cFrom     - coin from
91     * _cOut      - coin out
92     * _vFrom     - value from
93     * _vOut      - value out
94     * _time      - max live time
95     * _sign      - keccak256
96     **/ 
97     function swap(bytes32 _tradeID, address _cFrom, address _cOut, uint256 _vFrom, uint256 _vOut, uint256 _time, bytes calldata _sign) payable external 
98     {
99         require(_cFrom != _cOut);
100         bytes32 _hashSwap = keccak256(abi.encodePacked(_tradeID, _cFrom, _cOut, _vFrom, _vOut, _time));
101         
102         if(now > _time) {
103             return;
104         }
105         
106         verifySign(_hashSwap, _sign, _tradeID);
107         swapList[_tradeID] = true;
108         
109         if (_cFrom == address(0x0)) {
110             require(msg.value > 0);
111             require(msg.value == _vFrom);
112         } else {
113             require(safeTransferFrom(_cFrom, msg.sender, address(this), _vFrom));
114         }
115         
116         if (_cOut == address(0x0)) {
117             msg.sender.transfer(_vOut);
118         } else {
119             require(safeTransfer(_cOut, msg.sender, _vOut));
120         }
121         
122         emit Swap(msg.sender, _tradeID, _cFrom, _cOut, _vFrom, _vOut);
123     }
124     
125     function verifySign(bytes32 _hashSwap, bytes memory _sign, bytes32 _tradeID) private view {
126         require(_hashSwap.recover(_sign) == owner);
127         require(!swapList[_tradeID]);
128     }
129     
130     function withdraw(address payable _to, address _token, uint256 _amount) external onlyOwner {
131         if (_token == address(0x0)) {
132             _to.transfer(_amount);
133         } else {
134             TokenERC20(_token).transfer(_to, _amount);
135         }
136     }
137     
138     /**
139     * _tradeID   - swap ID
140     * _cFrom     - coin from
141     * _vFrom     - value from
142     * _time      - max live time
143     * _sign      - keccak256
144     **/ 
145     function swapAltChain(bytes32 _tradeID, address _cFrom, uint256 _vFrom, uint256 _time, bytes calldata _sign) payable external 
146     {
147         bytes32 _hashSwap = keccak256(abi.encodePacked(_tradeID, _cFrom, _vFrom, _time));
148         
149         if(now > _time) {
150             return;
151         }
152         
153         verifySign(_hashSwap, _sign, _tradeID);
154         swapList[_tradeID] = true;
155         
156         if (_cFrom == address(0x0)) {
157             require(msg.value > 0);
158             require(msg.value == _vFrom);
159         } else {
160             require(safeTransferFrom(_cFrom, msg.sender, address(this), _vFrom));
161         }
162         
163         emit SwapAltChain(msg.sender, _tradeID, _cFrom, _vFrom);
164     }
165     
166     function transferAltChain(bytes32 _tradeID, address payable _to, address _token, uint256 _amount) external onlyOwner {
167         if (_token == address(0x0)) {
168             _to.transfer(_amount);
169         } else {
170             TokenERC20(_token).transfer(_to, _amount);
171         }
172         emit TransferAltChain(_tradeID, _to, _token, _amount);
173     }
174     
175     function addEth() payable external
176     {
177         emit AddEth(msg.value);
178     }
179     
180     function safeTransfer(address token, address to , uint value) private returns (bool result) {
181         TokenERC20(token).transfer(to,value);
182 
183         assembly {
184             switch returndatasize()   
185                 case 0 {
186                     result := not(0)
187                 }
188                 case 32 {
189                     returndatacopy(0, 0, 32)
190                     result := mload(0)
191                 }
192                 default {
193                     revert(0, 0)
194                 }
195         }
196         require(result);
197     }
198     
199     function safeTransferFrom(address token, address _from, address to, uint value) private returns (bool result) {
200         TokenERC20(token).transferFrom(_from, to, value);
201 
202         assembly {
203             switch returndatasize()   
204                 case 0 {
205                     result := not(0)
206                 }
207                 case 32 {
208                     returndatacopy(0, 0, 32) 
209                     result := mload(0)
210                 }
211                 default {
212                     revert(0, 0) 
213                 }
214         }
215         require(result);
216     }
217 }