1 // Copyright (C) OPC Team
2 contract ERC20 {
3     function totalSupply() constant returns (uint supply);
4     function balanceOf( address who ) constant returns (uint value);
5     function allowance( address owner, address spender ) constant returns (uint _allowance);
6 
7     function transfer( address to, uint value) returns (bool ok);
8     function transferFrom( address from, address to, uint value) returns (bool ok);
9     function approve( address spender, uint value ) returns (bool ok);
10 
11     event Transfer( address indexed from, address indexed to, uint value);
12     event Approval( address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract DSMath {
16 
17     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         assert((z = x + y) >= x);
19     }
20 
21     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
22         assert((z = x - y) <= x);
23     }
24 
25 }
26 
27 contract OPC is ERC20,DSMath {
28     uint256                                            _supply;
29     mapping (address => uint256)                       _balances;
30     mapping (address => mapping (address => uint256))  _approvals;
31 
32     string   public  symbol;
33     string   public  name;
34     uint256  public  decimals = 18;
35     address  public  owner;
36     bool     public  stopped;
37 
38     uint256  public maxSupply=1000000000 ether;
39 
40 
41     function OPC(string _symbol,string _name,address _owner) {
42         symbol=_symbol;
43         name=_name;
44         owner=_owner;
45     }
46 
47     modifier auth {
48         assert (msg.sender==owner);
49         _;
50     }
51     modifier stoppable {
52         assert (!stopped);
53         _;
54     }
55     function stop() auth  {
56         stopped = true;
57     }
58     function start() auth  {
59         stopped = false;
60     }
61 
62     function totalSupply() constant returns (uint256) {
63         return _supply;
64     }
65     function balanceOf(address src) constant returns (uint256) {
66         return _balances[src];
67     }
68     function allowance(address src, address guy) constant returns (uint256) {
69         return _approvals[src][guy];
70     }
71 
72     function transfer(address dst, uint wad) stoppable returns (bool) {
73         assert(_balances[msg.sender] >= wad);
74 
75         _balances[msg.sender] = sub(_balances[msg.sender], wad);
76         _balances[dst] = add(_balances[dst], wad);
77 
78         Transfer(msg.sender, dst, wad);
79 
80         return true;
81     }
82 
83     function transferFrom(address src, address dst, uint wad)stoppable returns (bool) {
84         assert(_balances[src] >= wad);
85         assert(_approvals[src][msg.sender] >= wad);
86 
87         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
88         _balances[src] = sub(_balances[src], wad);
89         _balances[dst] = add(_balances[dst], wad);
90 
91         Transfer(src, dst, wad);
92 
93         return true;
94     }
95 
96     function approve(address guy, uint256 wad) stoppable returns (bool) {
97         _approvals[msg.sender][guy] = wad;
98 
99         Approval(msg.sender, guy, wad);
100 
101         return true;
102     }
103     function mint(address dst,uint128 wad) auth stoppable {
104         assert(add(_supply,wad)<=maxSupply);
105         _balances[dst] = add(_balances[dst], wad);
106         _supply = add(_supply, wad);
107     }
108 
109     event LogSetOwner     (address indexed owner);
110 
111     function setOwner(address owner_) auth
112     {
113         owner = owner_;
114         LogSetOwner(owner);
115     }
116 }