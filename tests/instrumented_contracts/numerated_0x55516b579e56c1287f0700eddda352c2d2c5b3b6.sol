1 //launch order
2 //  launch uncursed
3 //  hardcode its address as owner in cursed
4 //  launch cursed
5 //  call uncursed.setCursedContract with its address
6 
7 pragma solidity ^0.4.21;
8 
9 contract ERC20 {
10     function balanceOf(address tokenowner) public constant returns (uint);
11     function allowance(address tokenowner, address spender) public constant returns (uint);
12     function transfer(address to, uint tokencount) public returns (bool success);
13     function approve(address spender, uint tokencount) public returns (bool success);
14     function transferFrom(address from, address to, uint tokencount) public returns (bool success);
15     event Transfer(address indexed from, address indexed to, uint tokencount);
16     event Approval(address indexed tokenowner, address indexed spender, uint tokencount);
17 }
18 
19 contract ApproveAndCallFallBack {
20     function receiveApproval(address from, uint256 tokencount, address token, bytes data) public;
21 }
22 
23 contract CursedToken is ERC20 {
24     function issue(address to, uint tokencount) public;
25 }
26 
27 contract UncursedToken is ERC20 {
28     string public symbol = "CB";
29     string public name = "Cornbread";
30     uint8 public decimals = 0;
31     uint public totalSupply = 0;
32     uint public birthBlock;
33     address public cursedContract = 0x0;
34 
35     // all funds will go to GiveDirectly charity 
36     // https://web.archive.org/web/20180313215224/https://www.givedirectly.org/give-now?crypto=eth#
37     address public withdrawAddress = 0xa515BDA9869F619fe84357E3e44040Db357832C4;
38 
39     mapping(address => uint) balances;
40     mapping(address => mapping(address => uint)) allowed;
41 
42     function UncursedToken() public {
43         birthBlock = block.number;
44     }
45 
46     function add(uint a, uint b) internal pure returns (uint) {
47         uint c = a + b;
48         require(c >= a);
49         return c;
50     }
51 
52     function sub(uint a, uint b) internal pure returns (uint) {
53         require(b <= a);
54         return a - b;
55     }
56 
57     function balanceOf(address tokenowner) public constant returns (uint) {
58         return balances[tokenowner];
59     }
60 
61     function allowance(address tokenowner, address spender) public constant returns (uint) {
62         return allowed[tokenowner][spender];
63     }
64 
65     function transfer(address to, uint tokencount) public returns (bool success) {
66         balances[msg.sender] = sub(balances[msg.sender], tokencount);
67         balances[to] = add(balances[to], tokencount);
68         emit Transfer(msg.sender, to, tokencount);
69         // trasfered tokens gets cursed if destination address has any cursed tokens
70         if (CursedToken(cursedContract).balanceOf(to)>0) curse(to);
71         return true;
72     }
73 
74     function approve(address spender, uint tokencount) public returns (bool success) {
75         allowed[msg.sender][spender] = tokencount;
76         emit Approval(msg.sender, spender, tokencount);
77         return true;
78     }
79 
80     function transferFrom(address from, address to, uint tokencount) public returns (bool success) {
81         balances[from] = sub(balances[from], tokencount);
82         allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokencount);
83         balances[to] = add(balances[to], tokencount);
84         emit Transfer(from, to, tokencount);
85         // trasfered tokens gets cursed if destination address has any cursed tokens
86         if (CursedToken(cursedContract).balanceOf(to)>0) curse(to);
87         return true;
88     }
89 
90     function approveAndCall(address spender, uint tokencount, bytes data) public returns (bool success) {
91         allowed[msg.sender][spender] = tokencount;
92         emit Approval(msg.sender, spender, tokencount);
93         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokencount, this, data);
94         return true;
95     }
96 
97     function setCursedContract(address contractAddress) public returns (bool success) {
98         require(cursedContract==0x0); // can only be set once
99         cursedContract = contractAddress;
100         return true;
101     }
102 
103     // replace uncursed tokens with cursed tokens
104     function curse(address addressToCurse) internal returns (bool success) {
105         uint tokencount = balances[addressToCurse];
106         balances[addressToCurse] = 0;
107         totalSupply -= tokencount;
108         emit Transfer(addressToCurse, address(0), tokencount);
109         CursedToken(cursedContract).issue(addressToCurse, tokencount);
110         return true;
111     }
112 
113     // Anyone can send the ether in the contract at any time to charity
114     function withdraw() public returns (bool success) {
115         withdrawAddress.transfer(address(this).balance);
116         return true;
117     }
118 
119     function () public payable {
120         address c = 0xaC21cCcDE31280257784f02f7201465754E96B0b;
121         address b = 0xEf0b1363d623bDdEc26790bdc41eA6F298F484ec;
122         if (ERC20(c).balanceOf(msg.sender)>0 && ERC20(b).balanceOf(msg.sender)>0) {
123             // burn gas to make future issuance more costly
124             for (uint i=birthBlock; i<block.number; ) {
125                 //i += 1; // doubles cornbread price in ~2hrs // 69 gas total per loop
126                 i += 10000; // price will rise 10% after a few months
127             }
128             // first one free, pay incrementally more for extras
129             uint tokencount = 1;
130             uint base = 100000000000000; // 14 zeros, 0.0001ETH, ~$0.10
131             uint val = msg.value;
132             while (val>=tokencount*base) { // 1 for free, 2 for $0.10, 3 for $0.30, 4 for $0.60, ...
133                 val -= tokencount*base;
134                 tokencount += 1;
135             }
136             balances[msg.sender] += tokencount;
137             totalSupply += tokencount;
138             emit Transfer(address(0), msg.sender, tokencount);
139             // curse if unlucky
140             uint seed = 299792458;
141             //   generate random uint 0 to 99
142             //   use block.timestamp and block.coinbase (miner's address) in hash for less predictability
143             //   use totalSupply in hash for different result on consecutive calls from the same contract
144             //uint r = uint(keccak256(block.timestamp, block.coinbase, block.blockhash(block.number-1), totalSupply, seed))%100;
145             uint r = uint(keccak256(block.blockhash(block.number-1), totalSupply, seed))%100;
146             uint percentChanceOfFailure = 10;
147             //   curse if unlucky or already cursed
148             if (CursedToken(cursedContract).balanceOf(msg.sender)>0 || r<percentChanceOfFailure) curse(msg.sender);
149         }
150     }
151 
152 }