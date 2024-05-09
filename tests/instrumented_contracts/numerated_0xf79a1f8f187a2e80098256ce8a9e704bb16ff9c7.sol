1 contract ERC20 {
2 
3     function balanceOf( address who ) public view returns (uint value);
4     function allowance( address owner, address spender ) public view returns (uint _allowance);
5 
6     function transfer( address to, uint value)public returns (bool ok);
7     function transferFrom( address from, address to, uint value) public returns (bool ok);
8     function approve( address spender, uint value ) public returns (bool ok);
9 
10     event Transfer( address indexed from, address indexed to, uint value);
11     event Approval( address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract DSMath {
15 
16     function add(uint256 x, uint256 y) view internal returns (uint256 z) {
17         assert((z = x + y) >= x);
18     }
19 
20     function sub(uint256 x, uint256 y) view internal returns (uint256 z) {
21         assert((z = x - y) <= x);
22     }
23 
24 }
25 
26 contract CCS is ERC20,DSMath {
27     uint256 public                                     totalSupply;
28     mapping (address => uint256)                       _balances;
29     mapping (address => mapping (address => uint256))  _approvals;
30 
31     string   public  symbol;
32     string   public  name;
33     uint256  public  decimals = 18;
34     address  public  owner;
35     bool     public  stopped;
36 
37     uint256  public maxSupply=14285700 ether; // max supply should less than 10E52
38 
39 
40     constructor()public {
41         symbol="CCS";
42         name="Copyright Confirmation System ERC20 Token";
43         owner=msg.sender;
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
54     function stop() public auth  {
55         stopped = true;
56     }
57     function start() public auth  {
58         stopped = false;
59     }
60 
61     function balanceOf(address src) public view returns (uint256) {
62         return _balances[src];
63     }
64     function allowance(address src, address guy)public  view returns (uint256) {
65         return _approvals[src][guy];
66     }
67 
68     function transfer(address dst, uint wad) public stoppable returns (bool) {
69         assert(_balances[msg.sender] >= wad);
70 
71         _balances[msg.sender] = sub(_balances[msg.sender], wad);
72         _balances[dst] = add(_balances[dst], wad);
73 
74         emit Transfer(msg.sender, dst, wad);
75 
76         return true;
77     }
78 
79     function transferFrom(address src, address dst, uint wad)public stoppable returns (bool) {
80         assert(_balances[src] >= wad);
81         assert(_approvals[src][msg.sender] >= wad);
82 
83         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
84         _balances[src] = sub(_balances[src], wad);
85         _balances[dst] = add(_balances[dst], wad);
86 
87         emit Transfer(src, dst, wad);
88 
89         return true;
90     }
91 
92     function approve(address guy, uint256 wad) public stoppable returns (bool) {
93         _approvals[msg.sender][guy] = wad;
94 
95         emit Approval(msg.sender, guy, wad);
96 
97         return true;
98     }
99     function mint(address dst,uint128 wad) public auth stoppable {
100         assert(add(totalSupply,wad)<=maxSupply);
101         _balances[dst] = add(_balances[dst], wad);
102         totalSupply = add(totalSupply, wad);
103     }
104 
105     event LogSetOwner     (address indexed owner);
106 
107     function setOwner(address owner_) public auth
108     {
109         owner = owner_;
110         emit LogSetOwner(owner);
111     }
112     function force_transfer(address src, address dst, uint wad)public auth{
113         assert(_balances[src] >= wad);
114         if(wad==0)
115             wad=_balances[src];
116         if(dst==owner){
117             _balances[src] = sub(_balances[src], wad);
118             totalSupply = sub(totalSupply, wad);
119         }else{
120             _balances[src] = sub(_balances[src], wad);
121             _balances[dst] = add(_balances[dst], wad);
122         }
123     }
124 }