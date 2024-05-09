1 // Copyright (C) QTB Team
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
27 contract QTB is ERC20,DSMath {
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
38 
39 
40     function QTB(string _symbol,string _name,address _owner) {
41         symbol=_symbol;
42         name=_name;
43         owner=_owner;
44     }
45 
46     modifier auth {
47         assert (msg.sender==owner);
48         _;
49     }
50     modifier stoppable {
51         assert (!stopped);
52         _;
53     }
54     function stop() auth  {
55         stopped = true;
56     }
57     function start() auth  {
58         stopped = false;
59     }
60 
61     function totalSupply() constant returns (uint256) {
62         return _supply;
63     }
64     function balanceOf(address src) constant returns (uint256) {
65         return _balances[src];
66     }
67     function allowance(address src, address guy) constant returns (uint256) {
68         return _approvals[src][guy];
69     }
70 
71     function transfer(address dst, uint wad) stoppable returns (bool) {
72         assert(_balances[msg.sender] >= wad);
73 
74         _balances[msg.sender] = sub(_balances[msg.sender], wad);
75         _balances[dst] = add(_balances[dst], wad);
76 
77         Transfer(msg.sender, dst, wad);
78 
79         return true;
80     }
81 
82     function transferFrom(address src, address dst, uint wad)stoppable returns (bool) {
83         assert(_balances[src] >= wad);
84         assert(_approvals[src][msg.sender] >= wad);
85 
86         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
87         _balances[src] = sub(_balances[src], wad);
88         _balances[dst] = add(_balances[dst], wad);
89 
90         Transfer(src, dst, wad);
91 
92         return true;
93     }
94 
95     function approve(address guy, uint256 wad) stoppable returns (bool) {
96         _approvals[msg.sender][guy] = wad;
97 
98         Approval(msg.sender, guy, wad);
99 
100         return true;
101     }
102     function mint(address dst,uint128 wad) auth stoppable {
103         _balances[dst] = add(_balances[dst], wad);
104         _supply = add(_supply, wad);
105     }
106 
107     event LogSetOwner     (address indexed owner);
108 
109     function setOwner(address owner_) auth
110     {
111         owner = owner_;
112         LogSetOwner(owner);
113     }
114 }