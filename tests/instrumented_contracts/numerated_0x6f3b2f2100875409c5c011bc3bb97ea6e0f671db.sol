1 pragma solidity ^0.4.25;
2 
3 contract ToknTalkToken {
4 
5     event Transfer(address indexed from, address indexed to, uint amount);
6     event Approval(address indexed owner, address indexed spender, uint amount);
7 
8     uint private constant MAX_UINT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
9 
10     address public mintSigner = msg.sender;
11     string public constant name = "https://tokntalk.club";
12     string public constant symbol = "TTT";
13     uint public constant decimals = 0;
14     uint public totalSupply = 0;
15     mapping (address => uint) public balanceOf;
16     mapping (address => mapping (address => uint)) public allowance;
17     mapping (address => uint) public mintedBy;
18 
19     function transfer(address to, uint amount) external returns (bool) {
20         require(to != address(this));
21         require(to != 0);
22         uint balanceOfMsgSender = balanceOf[msg.sender];
23         require(balanceOfMsgSender >= amount);
24         balanceOf[msg.sender] = balanceOfMsgSender - amount;
25         balanceOf[to] += amount;
26         emit Transfer(msg.sender, to, amount);
27         return true;
28     }
29 
30     function transferFrom(address from, address to, uint amount) external returns (bool) {
31         require(to != address(this));
32         require(to != 0);
33         uint allowanceMsgSender = allowance[from][msg.sender];
34         require(allowanceMsgSender >= amount);
35         if (allowanceMsgSender != MAX_UINT) {
36             allowance[from][msg.sender] = allowanceMsgSender - amount;
37         }
38         uint balanceOfFrom = balanceOf[from];
39         require(balanceOfFrom >= amount);
40         balanceOf[from] = balanceOfFrom - amount;
41         balanceOf[to] += amount;
42         emit Transfer(from, to, amount);
43         return true;
44     }
45 
46     function approve(address spender, uint amount) external returns (bool) {
47         allowance[msg.sender][spender] = amount;
48         emit Approval(msg.sender, spender, amount);
49         return true;
50     }
51 
52     function mintUsingSignature(uint max, uint8 v, bytes32 r, bytes32 s) external {
53         bytes memory maxString = toString(max);
54         bytes memory messageLengthString = toString(124 + maxString.length);
55         bytes32 hash = keccak256(abi.encodePacked(
56             "\x19Ethereum Signed Message:\n",
57             messageLengthString,
58             "I approve address 0x",
59             toHexString(msg.sender),
60             " to mint token 0x",
61             toHexString(this),
62             " up to ",
63             maxString
64         ));
65         require(ecrecover(hash, v, r, s) == mintSigner);
66         uint mintedByMsgSender = mintedBy[msg.sender];
67         require(max >= mintedByMsgSender);
68         uint minting = max - mintedByMsgSender;
69         totalSupply += minting;
70         balanceOf[msg.sender] += minting;
71         mintedBy[msg.sender] = max;
72         emit Transfer(0, msg.sender, minting);
73     }
74 
75     function toString(uint value) private pure returns (bytes) {
76         uint tmp = value;
77         uint lengthOfValue;
78         do {
79             lengthOfValue++;
80             tmp /= 10;
81         } while (tmp != 0);
82         bytes memory valueString = new bytes(lengthOfValue);
83         while (lengthOfValue != 0) {
84             valueString[--lengthOfValue] = bytes1(48 + value % 10);
85             value /= 10;
86         }
87         return valueString;
88     }
89 
90     function toHexString(address addr) private pure returns (bytes) {
91         uint addrUint = uint(addr);
92         uint lengthOfAddr = 40;
93         bytes memory addrString = new bytes(lengthOfAddr);
94         while (addrUint != 0) {
95             addrString[--lengthOfAddr] = bytes1((addrUint % 16 < 10 ? 0x30 : 0x57) + addrUint % 16);
96             addrUint /= 16;
97         }
98         return addrString;
99     }
100 
101     function setMintSigner(address newMintSigner) external {
102         require(msg.sender == mintSigner);
103         mintSigner = newMintSigner;
104     }
105 }