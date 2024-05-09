1 pragma solidity ^0.4.18 ;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract ContractiumInterface {
32     function balanceOf(address who) public view returns (uint256);
33     function transferFrom(address from, address to, uint256 value) public returns (bool);
34     function contractSpend(address _from, uint256 _value) public returns (bool);
35     function allowance(address _owner, address _spender) public view returns (uint256);
36     function owner() public view returns (address);
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 }
59 
60 contract AirdropContractium is Ownable {
61     
62     
63     using SafeMath for uint256;
64     
65     //Contractium contract interface
66     ContractiumInterface ctuContract;
67 
68     //Store addresses submitted
69     mapping(address => bool) submitted;
70     
71     uint8 public constant decimals = 18;
72     uint256 public constant INITIAL_AIRDROP = 20000000 * (10 ** uint256(decimals));
73     address public constant CTU_ADDRESS = 0x943ACa8ed65FBf188A7D369Cfc2BeE0aE435ee1B;
74     address public ctu_owner = 0x69f4965e77dFF568cF2f8877F2B39d636D581ae8;
75     
76     uint256 public reward = 200 * (10 ** uint256(decimals));
77     uint256 public remainAirdrop;
78    
79     event Submit(address _addr, bool _isSuccess);
80    
81     constructor() public {
82         owner = msg.sender;
83         remainAirdrop = INITIAL_AIRDROP;
84         ctuContract = ContractiumInterface(CTU_ADDRESS);
85     }
86     
87     function getAirdrop() public isNotSubmitted isRemain returns (bool) {
88         return submit(msg.sender);
89     }
90     
91     function batchSubmit(address[] _addresses) public onlyOwner {
92         for(uint i; i < _addresses.length; i++) {
93             if (!submitted[_addresses[i]]) {
94                 submit(_addresses[i]);
95             }
96         }
97     }
98     
99     
100     function submit(address _addr) private returns (bool) {
101         address _from = ctu_owner;
102         address _to = _addr;
103         uint256 _value = uint256(reward);
104         bool isSuccess = ctuContract.transferFrom(_from, _to, _value);
105         
106         if (isSuccess) {
107             submitted[_to] = true;
108             remainAirdrop = remainAirdrop.sub(_value);
109         }
110         
111         emit Submit(_addr, isSuccess);
112         
113         closeAirdrop();
114         return isSuccess;
115     }
116     
117     
118     modifier isNotSubmitted() {
119         require(!submitted[msg.sender]);
120         _;
121     }
122     
123     modifier isRemain() {
124         require(remainAirdrop > 0);
125         require(reward > 0);
126         _;
127     }
128     
129     function closeAirdrop() private {
130         address _owner = ctu_owner;
131         address _spender = address(this);
132         uint256 _remain = ctuContract.allowance(_owner, _spender);
133         
134         if (_remain < reward) {
135             reward = 0;
136             remainAirdrop = 0;
137         }
138     }
139   
140     function setCtuContract(address _ctuAddress) public onlyOwner  returns (bool) {
141         require(_ctuAddress != address(0x0));
142         ctuContract = ContractiumInterface(_ctuAddress);
143         ctu_owner = ctuContract.owner();
144         return true;
145     }
146     
147     function setRemainAirdrop(uint256 _remain) public onlyOwner  returns (bool) {
148         remainAirdrop = _remain;
149         return true;
150     }
151     
152     function setReward(uint256 _reward) public onlyOwner  returns (bool) {
153         reward = _reward;
154         return true;
155     }
156 
157     function transferOwnership(address _addr) public onlyOwner {
158         super.transferOwnership(_addr);
159     }
160 
161 }