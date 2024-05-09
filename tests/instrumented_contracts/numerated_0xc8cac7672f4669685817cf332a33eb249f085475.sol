1 pragma solidity 0.4.24;
2 
3 
4 interface ERC20 {
5 
6     event Transfer(address indexed from, address indexed to, uint256 value);
7     event Approval(address indexed owner, address indexed spender, uint256 value);
8 
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address _who) public view returns (uint256);
11     function allowance(address _owner, address _spender) public view returns (uint256);
12     function transfer(address _to, uint256 _value) public returns (bool);
13     function approve(address _spender, uint256 _value) public returns (bool);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 }
16 
17 contract Ownable {
18     address private owner_;
19     event OwnershipRenounced(address indexed previousOwner);
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     
23     constructor() public {
24         owner_ = msg.sender;
25     }
26 
27     
28     function owner() public view returns(address) {
29         return owner_;
30     }
31 
32     
33     modifier onlyOwner() {
34         require(msg.sender == owner_, "Only the owner can call this function.");
35         _;
36     }
37 
38     
39     function renounceOwnership() public onlyOwner {
40         emit OwnershipRenounced(owner_);
41         owner_ = address(0);
42     }
43 
44     
45     function transferOwnership(address _newOwner) public onlyOwner {
46         _transferOwnership(_newOwner);
47     }
48 
49     
50     function _transferOwnership(address _newOwner) internal {
51         require(_newOwner != address(0), "Cannot transfer ownership to zero address.");
52         emit OwnershipTransferred(owner_, _newOwner);
53         owner_ = _newOwner;
54     }
55 }
56 
57 library SafeMath {
58 
59     
60     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
61         
62         
63         
64         if (_a == 0) {
65             return 0;
66         }
67 
68         c = _a * _b;
69         assert(c / _a == _b);
70         return c;
71     }
72 
73     
74     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
75         
76         
77         
78         return _a / _b;
79     }
80 
81     
82     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
83         assert(_b <= _a);
84         return _a - _b;
85     }
86 
87     
88     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
89         c = _a + _b;
90         assert(c >= _a);
91         return c;
92     }
93 }
94 
95 contract LivenCoin is ERC20, Ownable {
96 
97     using SafeMath for uint256;
98 
99     string private name_ = "LivenCoin";
100     string private symbol_ = "LVN";
101     uint256 private decimals_ = 18;
102     uint256 public initialAmount = 10000000000 * (10 ** decimals_);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106     
107     mapping (address => uint256) internal balances_;
108     mapping (address => mapping (address => uint256)) private allowed_;
109 
110     uint256 internal totalSupply_;
111     bool public unlocked = false;
112 
113     modifier afterUnlock() {
114         require(unlocked || msg.sender == owner(), "Only owner can call this function before unlock.");
115         _;
116     }
117 
118     constructor() public {
119         totalSupply_ = totalSupply_.add(initialAmount);
120         balances_[msg.sender] = balances_[msg.sender].add(initialAmount);
121         emit Transfer(address(0), msg.sender, initialAmount);
122     }
123 
124     function() public payable { revert("Cannot send ETH to this address."); }
125     
126     function name() public view returns(string) {
127         return name_;
128     }
129 
130     function symbol() public view returns(string) {
131         return symbol_;
132     }
133 
134     function decimals() public view returns(uint256) {
135         return decimals_;
136     }
137 
138     function safeTransfer(address _to, uint256 _value) public afterUnlock {
139         require(transfer(_to, _value), "Transfer failed.");
140     }
141 
142     function safeTransferFrom(address _from, address _to, uint256 _value) public afterUnlock {
143         require(transferFrom(_from, _to, _value), "Transfer failed.");
144     }
145 
146     function safeApprove( address _spender, uint256 _currentValue, uint256 _value ) public afterUnlock {
147         require(allowed_[msg.sender][_spender] == _currentValue, "Current allowance value does not match.");
148         approve(_spender, _value);
149     }
150 
151     
152     function totalSupply() public view returns (uint256) {
153         return totalSupply_;
154     }
155 
156     function balanceOf(address _owner) public view returns (uint256) {
157         return balances_[_owner];
158     }
159 
160     function unlock() public onlyOwner {
161         unlocked = true;
162     }
163 
164     function allowance(address _owner, address _spender) public view returns (uint256) {
165         return allowed_[_owner][_spender];
166     }
167 
168     function transfer(address _to, uint256 _value) public afterUnlock returns (bool) {
169         require(_value <= balances_[msg.sender], "Value exceeds balance of msg.sender.");
170         require(_to != address(0), "Cannot send tokens to zero address.");
171 
172         balances_[msg.sender] = balances_[msg.sender].sub(_value);
173         balances_[_to] = balances_[_to].add(_value);
174         emit Transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     function approve(address _spender, uint256 _value) public afterUnlock returns (bool) {
179         allowed_[msg.sender][_spender] = _value;
180         emit Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _value) public afterUnlock returns (bool) {
185         require(_value <= balances_[_from], "Value exceeds balance of msg.sender.");
186         require(_value <= allowed_[_from][msg.sender], "Value exceeds allowance of msg.sender for this owner.");
187         require(_to != address(0), "Cannot send tokens to zero address.");
188 
189         balances_[_from] = balances_[_from].sub(_value);
190         balances_[_to] = balances_[_to].add(_value);
191         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
192         emit Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     function increaseApproval(address _spender, uint256 _addedValue) public afterUnlock returns (bool) {
197         allowed_[msg.sender][_spender] = allowed_[msg.sender][_spender].add(_addedValue);
198         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
199         return true;
200     }
201 
202     function decreaseApproval(address _spender, uint256 _subtractedValue) public afterUnlock returns (bool) {
203         uint256 oldValue = allowed_[msg.sender][_spender];
204         if (_subtractedValue >= oldValue) {
205             allowed_[msg.sender][_spender] = 0;
206         } else {
207             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208         }
209         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
210         return true;
211     }
212 }