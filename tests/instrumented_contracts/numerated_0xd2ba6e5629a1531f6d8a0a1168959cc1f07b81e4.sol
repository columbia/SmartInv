1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15   function transferOwnership(address newOwner) public onlyOwner {
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 }
21 
22 interface TokenContract {
23   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
24 }
25 
26 contract SafeWithdraw is Ownable {
27   address signerAddress = 0xDD594FeD73370549607A658DfE7737C437265BBC;
28   TokenContract public tkn;
29   address public tokenWallet;
30   mapping (bytes32 => bool) public claimed;
31 
32   constructor() public {
33     tkn = TokenContract(0x92D3e963aA94D909869940A8d15FA16CcbC6655E);
34     tokenWallet = 0x850Ac570A9f4817C43722938127aFa504aeb7717;
35   }
36 
37   function changeWallet(address _newWallet) onlyOwner public {
38     tokenWallet = _newWallet;
39   }
40 
41   function changeSigner(address _newSigner) onlyOwner public {
42     signerAddress = _newSigner;
43   }
44 
45   function transfer(uint256 _amount, string code, bytes sig) public {
46     bytes32 message = prefixed(keccak256(_amount, code));
47     
48     require (!claimed[message]);
49 
50     if (recoverSigner(message, sig) == signerAddress) {
51       uint256 fullValue = _amount * (1 ether);
52       claimed[message] = true;
53       tkn.transferFrom(tokenWallet, msg.sender, fullValue);
54       emit Claimed(msg.sender, fullValue);
55     }
56   }
57 
58   function killMe() public {
59     require(msg.sender == owner);
60     selfdestruct(msg.sender);
61   }
62 
63   function splitSignature(bytes sig)
64     internal
65     pure
66     returns (uint8, bytes32, bytes32)
67   {
68     require(sig.length == 65);
69     bytes32 r;
70     bytes32 s;
71     uint8 v;
72 
73     assembly {
74       r := mload(add(sig, 32))
75       s := mload(add(sig, 64))
76       v := byte(0, mload(add(sig, 96)))
77     }
78     return (v, r, s);
79   }
80 
81   function recoverSigner(bytes32 message, bytes sig)
82     internal
83     pure
84     returns (address)
85   {
86     uint8 v;
87     bytes32 r;
88     bytes32 s;
89     (v, r, s) = splitSignature(sig);
90     return ecrecover(message, v, r, s);
91   }
92 
93   function prefixed(bytes32 hash) internal pure returns (bytes32) {
94     return keccak256("\x19Ethereum Signed Message:\n32", hash);
95   }
96 
97   event Claimed(address _by, uint256 _amount);
98 
99 }