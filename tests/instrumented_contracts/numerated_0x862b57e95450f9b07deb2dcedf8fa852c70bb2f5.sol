1 pragma solidity ^0.4.25;
2 
3 
4 library SafeMath {
5     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a && c >= b);
8         return c;
9     }
10 
11     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a - b;
13         require(c <= a && c <= b);
14         return c;
15     }
16 
17     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a * b;
19         require(a == c/a && b == c/b);
20         return c;
21     }
22 
23     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(a != 0 && b != 0);
25         uint256 c = a/b;
26         require(a == b * c + a % b);
27         return c;
28     }
29 }
30 
31 
32 contract T {
33     // use SafeMath for uint256 mul div add sub
34     using SafeMath for *;
35     address public owner;
36     uint256 public totalSupply;
37     uint256 public decimal;
38     string public symbol;
39     string public name;
40 
41     mapping (address => uint256) internal balance;
42     mapping (uint256 => address) internal tokenIndexToAddress; // record every address owned token
43     mapping (address => mapping (address => uint256)) internal allowance;
44     mapping (address => uint256) internal amountToFrozenAddress; // record token amount that address been forzen
45 
46     // 88888,8,"T","center for digital finacial assets"
47     constructor(
48         uint256 _totalSupply,
49         uint256 _decimal,
50         string _symbol,
51         string _name
52     ) public {
53         owner = msg.sender;
54         totalSupply = _totalSupply;
55         decimal = _decimal;
56         symbol = _symbol;
57         name = _name;
58         balance[msg.sender] = _totalSupply;
59 
60     }
61 
62     event TransferTo(address indexed _from, address indexed _to, uint256 _amount);
63     event ApproveTo(address indexed _from, address indexed _spender, uint256 _amount);
64     // event froze and un froze
65     event FrozenAddress(address indexed _owner, uint256 _amount);
66     event UnFrozenAddress(address indexed _owner, uint256 _amount);
67     // owner's token been burn
68     event Burn(address indexed _owner, uint256 indexed _amount);
69 
70     modifier onlyHolder() {
71         require(msg.sender == owner, "only holder can call this function");
72         _;
73     }
74 
75     // require available_balance > total_balance -forzen_balance
76     modifier isAvailableEnough(address _owner, uint256 _amount) {
77         require(balance[_owner].safeSub(amountToFrozenAddress[_owner]) >= _amount, "no enough available balance");
78         _;
79     }
80 
81     // this contract not acccpt ether transfer
82     function () public payable {
83         revert("can not recieve ether");
84     }
85 
86     // set new owner
87     function setOwner(address _newOwner) public onlyHolder {
88         require(_newOwner != address(0));
89         owner = _newOwner;
90     }
91 
92     function balanceOf(address _account) public view returns (uint256) {
93         require(_account != address(0));
94         return balance[_account];
95     }
96 
97     function getTotalSupply()public view returns (uint256) {
98         return totalSupply;
99     }
100 
101     function transfer(address _to, uint256 _amount) public isAvailableEnough(msg.sender, _amount) {
102        //not transfer to 0 account
103         require(_to != address(0));
104         balance[msg.sender] = balance[msg.sender].safeSub(_amount);
105         balance[_to] = balance[_to].safeAdd(_amount);
106         // record address which owned token
107         // tokenIndexToAccount[accountNumber] = _to;
108         emit TransferTo(msg.sender, _to, _amount);
109     }
110 
111     // approve will reset old allowance and give a new allowance to privileges address,
112     //allowance allowed larger than balance[msg.sender]
113     function approve(address _spender, uint256 _amount) public {
114         require(_spender != address(0));
115         allowance[msg.sender][_spender] = _amount;
116         emit ApproveTo(msg.sender, _spender, _amount);
117     }
118 
119     function transferFrom(address _from, address _to, uint256 _amount) public isAvailableEnough(_from, _amount) {
120         require(_from != address(0) && _to != address(0));
121         //require(_amount == uint256(_amount));
122         //require(allowance[_from][msg.sender] >= _amount && balance[_from] >= _amount);
123         balance[_from] = balance[_from].safeSub(_amount);
124         balance[_to] = balance[_to].safeAdd(_amount);
125         allowance[_from][msg.sender] = allowance[_from][msg.sender].safeSub(_amount);
126         emit TransferTo(_from, _to, _amount);
127     }
128 
129     // froze token owned by _woner address
130     function froze(address _owner, uint256 _amount) public onlyHolder {
131         amountToFrozenAddress[_owner] = _amount;
132         emit FrozenAddress(_owner, _amount);
133     }
134 
135     function unFroze(address _owner, uint256 _amount) public onlyHolder {
136         amountToFrozenAddress[_owner] = amountToFrozenAddress[_owner].safeSub(_amount);
137         emit UnFrozenAddress(_owner, _amount);
138     }
139 
140     // burn token owned by _woner address and decrease totalSupply permanently
141     function burn(address _owner, uint256 _amount) public onlyHolder {
142         require(_owner != address(0));
143         balance[_owner] = balance[_owner].safeSub(_amount);
144         totalSupply = totalSupply.safeSub(_amount);
145         emit Burn(_owner, _amount);
146     }
147 }