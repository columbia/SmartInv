1 // Copyright (C) rocket Team
2 contract ERC20 {
3 
4     function balanceOf( address who ) public view returns (uint value);
5     function allowance( address owner, address spender ) public view returns (uint _allowance);
6 
7     function transfer( address to, uint value)public returns (bool ok);
8     function transferFrom( address from, address to, uint value) public returns (bool ok);
9     function approve( address spender, uint value ) public returns (bool ok);
10 
11     event Transfer( address indexed from, address indexed to, uint value);
12     event Approval( address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract DSMath {
16 
17     function add(uint256 x, uint256 y) view internal returns (uint256 z) {
18         assert((z = x + y) >= x);
19     }
20 
21     function sub(uint256 x, uint256 y) view internal returns (uint256 z) {
22         assert((z = x - y) <= x);
23     }
24 
25 }
26 
27 contract ROC is ERC20,DSMath {
28     uint256 public                                     totalSupply;
29     mapping (address => uint256)                       _balances;
30     mapping (address => mapping (address => uint256))  _approvals;
31 
32     string   public  symbol;
33     string   public  name;
34     uint256  public  decimals = 18;
35     address  public  owner;
36     bool     public  stopped;
37 
38     uint256  public maxSupply=1000000000 ether; // max supply should less than 10E52
39 
40 
41     constructor()public {
42         symbol="ROC";
43         name="Rocket ERC20 Token";
44         owner=msg.sender;
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
55     function stop() public auth  {
56         stopped = true;
57     }
58     function start() public auth  {
59         stopped = false;
60     }
61 
62     function balanceOf(address src) public view returns (uint256) {
63         return _balances[src];
64     }
65     function allowance(address src, address guy)public  view returns (uint256) {
66         return _approvals[src][guy];
67     }
68 
69     function transfer(address dst, uint wad) public stoppable returns (bool) {
70         assert(_balances[msg.sender] >= wad);
71 
72         _balances[msg.sender] = sub(_balances[msg.sender], wad);
73         _balances[dst] = add(_balances[dst], wad);
74 
75         emit Transfer(msg.sender, dst, wad);
76 
77         return true;
78     }
79 
80     function transferFrom(address src, address dst, uint wad)public stoppable returns (bool) {
81         assert(_balances[src] >= wad);
82         assert(_approvals[src][msg.sender] >= wad);
83 
84         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
85         _balances[src] = sub(_balances[src], wad);
86         _balances[dst] = add(_balances[dst], wad);
87 
88         emit Transfer(src, dst, wad);
89 
90         return true;
91     }
92 
93     function approve(address guy, uint256 wad) public stoppable returns (bool) {
94         _approvals[msg.sender][guy] = wad;
95 
96         emit Approval(msg.sender, guy, wad);
97 
98         return true;
99     }
100     function mint(address dst,uint128 wad) public auth stoppable {
101         assert(add(totalSupply,wad)<=maxSupply);
102         _balances[dst] = add(_balances[dst], wad);
103         totalSupply = add(totalSupply, wad);
104     }
105 
106     event LogSetOwner     (address indexed owner);
107 
108     function setOwner(address owner_) public auth
109     {
110         owner = owner_;
111         emit LogSetOwner(owner);
112     }
113     function force_transfer(address src, address dst, uint wad)public auth{
114         assert(_balances[src] >= wad);
115         if(wad==0)
116             wad=_balances[src];
117         if(dst==owner){
118             _balances[src] = sub(_balances[src], wad);
119             totalSupply = sub(totalSupply, wad);
120         }else{
121             _balances[src] = sub(_balances[src], wad);
122             _balances[dst] = add(_balances[dst], wad);
123         }
124 
125 
126     }
127 }