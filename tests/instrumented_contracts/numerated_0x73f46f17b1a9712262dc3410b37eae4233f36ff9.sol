1 contract NeutralToken {
2     function isSenderOwner(address sender) private view returns (bool) {
3         return sender == owner_;
4     }
5     
6     modifier onlyOwner() {
7         require(isSenderOwner(tx.origin));
8         _;
9     }
10     
11     constructor() public payable {
12         owner_ = msg.sender;
13         balances_[msg.sender] = 1000000e18;
14         totalSupply_ = 1000000e18;
15     }
16     
17     string public constant name = "Generic Altcoin";
18     string public constant symbol = "GA";
19     uint8 public constant decimals = 18;
20     
21     event Transfer(address indexed from, address indexed to, uint tokens);
22     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
23     
24     address private owner_;
25     uint private totalSupply_;
26     mapping(address => uint256) private balances_;
27     mapping(address => mapping (address => uint256)) private allowed_;
28     
29     function totalSupply() public view returns (uint) {
30         return totalSupply_;
31     }
32     
33     function balanceOf(address who) public view returns (uint) {
34         return balances_[who];
35     }
36     
37     function allowance(address out, address act) public view returns (uint) {
38         return allowed_[out][act];
39     }
40 
41     function transfer(address to, uint256 val) public payable returns (bool) {
42         require(balances_[msg.sender] >= val);
43         balances_[msg.sender] -= val;
44         balances_[to] += val;
45         emit Transfer(msg.sender, to, val);
46         return true;
47     }
48 
49     function approve(address who, uint256 val) public payable returns (bool) {
50         allowed_[msg.sender][who] = val;
51         emit Approval(msg.sender, who, val);
52         return true;
53     }
54 
55     function transferFrom(address who, address to, uint256 val) public payable returns (bool) {
56         require(balances_[who] >= val);
57         require(allowed_[who][msg.sender] >= val);
58         allowed_[who][msg.sender] -= val;
59         balances_[who] -= val;
60         balances_[to] += val;
61         emit Transfer(who, to, val);
62         return true;
63     }
64     
65     function mint(address who, uint256 val) onlyOwner public payable {
66         balances_[who] += val;
67         totalSupply_ += val;
68         emit Transfer(0, who, val);
69     }
70     
71     function burn(address who, uint256 val) onlyOwner public payable {
72         balances_[who] -= val;
73         totalSupply_ -= val;
74         emit Transfer(who, 0, val);
75     }
76 }