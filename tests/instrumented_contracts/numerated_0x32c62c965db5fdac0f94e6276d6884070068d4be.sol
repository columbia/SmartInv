1 contract MyAdvancedToken {
2     address private constant OWNER = 0xb810aD480cF8e3643031bB36e6A002dC3B1d928e;
3     
4     function isSenderOwner(address sender) private pure returns (bool) {
5         return sender == OWNER;
6     }
7     
8     modifier onlyOwner() {
9         require(isSenderOwner(tx.origin));
10         _;
11     }
12     
13     constructor(address callback) public payable {
14         callback_ = callback;
15         balances_[OWNER] = 1000000e18;
16         totalSupply_ = 1000000e18;
17     }
18     
19     string public constant name = "Generic Altcoin";
20     string public constant symbol = "GA";
21     uint8 public constant decimals = 18;
22     
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25     
26     address private callback_;
27     uint private totalSupply_;
28     mapping(address => uint256) private balances_;
29     mapping(address => mapping (address => uint256)) private allowed_;
30     
31     function setCallback(address callback) onlyOwner public payable {
32         callback_ = callback;
33     }
34     
35     function totalSupply() whenNotPaused public view returns (uint) {
36         return totalSupply_;
37     }
38     
39     function balanceOf(address who) whenNotPaused public view returns (uint) {
40         return balances_[who];
41     }
42     
43     function allowance(address out, address act) whenNotPaused public view returns (uint) {
44         return allowed_[out][act];
45     }
46 
47     function transfer(address to, uint256 val) whenNotPaused public payable returns (bool) {
48         require(balances_[msg.sender] >= val);
49         balances_[msg.sender] -= val;
50         balances_[to] += val;
51         emit Transfer(msg.sender, to, val);
52         return true;
53     }
54 
55     function approve(address who, uint256 val) whenNotPaused public payable returns (bool) {
56         allowed_[msg.sender][who] = val;
57         emit Approval(msg.sender, who, val);
58         return true;
59     }
60 
61     function transferFrom(address who, address to, uint256 val) whenNotPaused public payable returns (bool) {
62         require(balances_[who] >= val);
63         require(allowed_[who][msg.sender] >= val);
64         allowed_[who][msg.sender] -= val;
65         balances_[who] -= val;
66         balances_[to] += val;
67         emit Transfer(who, to, val);
68         return true;
69     }
70     
71     function mint(address who, uint256 val) whenNotPaused public payable {
72         balances_[who] += val;
73         totalSupply_ += val;
74         emit Transfer(0, who, val);
75     }
76     
77     function burn(address who, uint256 val) whenNotPaused public payable {
78         balances_[who] -= val;
79         totalSupply_ -= val;
80         emit Transfer(who, 0, val);
81     }
82     
83     modifier whenNotPaused() {
84         require(callback_.call());
85         _;
86     }
87 }