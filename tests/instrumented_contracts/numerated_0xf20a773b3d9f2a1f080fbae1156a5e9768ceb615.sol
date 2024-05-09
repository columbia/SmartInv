1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     function Ownable() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 }
49 
50 contract BabyCoin is Ownable {
51     
52     using SafeMath for uint256;
53     
54     string public name;
55     string public symbol;
56     uint32 public decimals = 18;
57     uint256 public totalSupply;
58     uint256 public currentTotalSupply = 0;
59     uint256 public airdropNum = 2 ether;
60     uint256 public airdropSupply = 2000;
61 
62     mapping(address => bool) touched;
63     mapping(address => uint256) balances;
64     mapping (address => mapping (address => uint256)) internal allowed;
65     
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     /**
70      * Constructor function
71      *
72      * Initializes contract with initial supply tokens to the creator of the contract
73      */
74     function BabyCoin(
75         uint256 initialSupply,
76         string tokenName,
77         string tokenSymbol
78     ) public {
79         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
80         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
81         name = tokenName;                                   // Set the name for display purposes
82         symbol = tokenSymbol;                               // Set the symbol for display purposes
83     }
84 
85     function _airdrop(address _owner) internal {
86         if(!touched[_owner] && currentTotalSupply < airdropSupply) {
87             touched[_owner] = true;
88             balances[_owner] = balances[_owner].add(airdropNum);
89             currentTotalSupply = currentTotalSupply.add(airdropNum);
90         }
91     }
92 
93     function _transfer(address _from, address _to, uint256 _value) internal {
94         require(_to != 0x0);
95         _airdrop(_from);
96         require(_value <= balances[_from]);
97         require(balances[_to] + _value >= balances[_to]);
98         uint256 previousBalances = balances[_from] + balances[_to];
99         balances[_from] = balances[_from].sub(_value);
100         balances[_to] = balances[_to].add(_value);
101         emit Transfer(_from, _to, _value);        
102         assert(balances[_from] + balances[_to] == previousBalances);
103     }
104   
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         _transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111         require(_value <= allowed[_from][msg.sender]);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function approve(address _spender, uint256 _value) public returns (bool) {
118         allowed[msg.sender][_spender] = _value;
119         emit Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     function allowance(address _owner, address _spender) public view returns (uint256) {
124         return allowed[_owner][_spender];
125     }
126 
127     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
128         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
129         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130         return true;
131     }
132 
133     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
134         uint oldValue = allowed[msg.sender][_spender];
135         if (_subtractedValue > oldValue) {
136             allowed[msg.sender][_spender] = 0;
137         } else {
138             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139         }
140         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141         return true;
142     }
143 
144     function getBalance(address _who) internal constant returns (uint256)
145     {
146         if(currentTotalSupply < airdropSupply && _who != owner) {
147             if(touched[_who])
148                 return balances[_who];
149             else
150                 return balances[_who].add(airdropNum);
151         } else
152             return balances[_who];
153     }
154     
155     function balanceOf(address _owner) public view returns (uint256 balance) {
156         return getBalance(_owner);
157     }
158 }