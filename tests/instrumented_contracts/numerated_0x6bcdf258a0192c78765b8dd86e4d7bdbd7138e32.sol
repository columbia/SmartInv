1 pragma solidity 0.4.25;
2 
3 /**
4  * @title Homburger Token
5  * @author Homburger Team
6  *
7  */
8 contract HomburgerToken {
9     string public constant name = "Homburger Token";
10     string public constant symbol = "HOM2";
11     uint256 public constant decimal = 18;
12     
13     address public owner;
14     uint256 private _totalSupply;
15     bool private _paused;
16     
17     mapping(address=>uint256) private balances;
18     mapping(address=>mapping(address=>uint256)) private allowed;
19     
20     event Transfer(address from, address to, uint256 value);
21     event Approval(address tokenHolder, address spender, uint256 value);
22     
23     constructor() public {
24         owner = msg.sender;
25         _paused = true;
26     }
27     
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32     
33     modifier whenNotPaused() {
34         require(!_paused);
35         _;
36     }
37     
38     modifier whenPaused() {
39         require(_paused);
40         _;
41     }
42     
43     function balanceOf(address tokenHolder) public view returns (uint256) {
44         return balances[tokenHolder];
45     }
46     
47     function totalSupply() public view returns(uint256) {
48         return _totalSupply;
49     }
50     
51     function transfer(address to, uint256 value) public whenNotPaused returns(bool) {
52         require(balances[msg.sender] >= value);
53         require(to != address(0));
54         
55         balances[msg.sender] -= value;
56         balances[to] += value;
57         emit Transfer(msg.sender, to, value);
58         return true;
59     }
60     
61     function allowance(address tokenHolder, address spender) public view returns(uint256) {
62         return allowed[tokenHolder][spender];
63     }
64     
65     function approve(address spender, uint256 value) public whenNotPaused returns(bool) {
66         require(spender != address(0));
67         
68         allowed[msg.sender][spender] = value;
69         emit Approval(msg.sender, spender, value);
70         return true;
71     }
72     
73     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns(bool) {
74         require(allowed[from][msg.sender] >= value);
75         require(balances[from] >= value);
76         require(to != address(0));
77         
78         allowed[from][msg.sender] -= value;
79         balances[from] -= value;
80         balances[to] += value;
81         emit Transfer(from, to, value);
82         return true;
83     }
84     
85     function mint(address to, uint256 value) public onlyOwner returns(bool) {
86         require(to != address(0));
87         
88         _totalSupply += value; // totalSupply = totalSupply + value
89         balances[to] += value;
90         emit Transfer(address(0), to , value);
91         return true;
92     }
93     
94     function paused() public view returns(bool) {
95         return _paused;
96     }
97     
98     function pause() public onlyOwner whenNotPaused {
99         _paused = true;
100     }
101     
102     function unpause() public onlyOwner whenPaused {
103         _paused = false;
104     }
105     
106     function transferOwnership(address newOwner) public onlyOwner {
107         require(newOwner != address(0));
108         
109         owner = newOwner;
110     }
111 }