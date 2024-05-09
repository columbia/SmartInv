1 pragma solidity ^0.4.18;
2 
3 
4 contract DI {
5     function ap(address u_) external;
6     function rb(address u_) external;
7     function ico(uint i_, address x_, uint c_) external;
8     function sco(uint i_, address x_, uint c_) external;
9     function gco(uint i_, address x_) public view returns (uint _c);
10     function gcp(uint ci_) public view returns (uint _c);
11     function cpn(uint ci_) external;
12     function gur(address x_, address y_) external returns (address _z);
13     function gcmp(uint i_, uint c_) public view returns (uint _c);
14     function cmpn(uint i_, uint c_) external;
15     function cg(address x_, uint gpc_, uint mg_, uint gc_) external;
16     function ggc(address x_) public view returns (uint _c);
17     function ggcd(address x_) public view returns (uint _c);
18     function guhb(address x_) public view returns (bool _c);
19     function gcsc(uint ci_) public view returns (uint _c);
20     function gcpn(uint ci_) public view returns (uint _c);
21     function gcpm(uint ci_) public view returns (uint _c);
22     function gcpa(uint ci_) public view returns (uint _c);
23     function gcsp(uint ci_) public view returns (uint _c);
24     function sc(uint ci_, uint csp_, uint cpm_, uint cpa_, uint csc_) external;
25     function irbg(address x_, uint c_) external;
26     function grg(address x_) public view returns (uint _c);
27 }
28 
29 contract Presale {
30     event EventBc(address x_, uint ci_);
31     event EventBmc(address x_, uint ci_, uint c_);
32     event EventCg(address x_);
33 
34     uint rb = 10;
35     uint GC = 10;
36     uint MG = 50;
37     uint GPC = 3;
38     uint npb = 50;
39 
40     DI di;
41     address public opAddr;
42     address private newOpAddr;
43 
44     function Presale() public {
45         opAddr = msg.sender;
46     }
47 
48 
49     function bc(uint ci_, address ref_) public payable {
50         uint cp_ = di.gcp(ci_);
51         require(cp_ > 0);
52         cp_ = cp_ * pf(msg.sender)/10000;
53         require(msg.value >= cp_);
54 
55         uint excessMoney = msg.value - cp_;
56 
57         di.cpn(ci_);
58         di.ico(ci_, msg.sender, 1);
59 
60         di.ap(msg.sender);
61         di.rb(msg.sender);
62 
63         EventBc(msg.sender, ci_);
64 
65         address rr = di.gur(msg.sender, ref_);
66         if(rr != address(0))
67             rr.transfer(cp_ * rb / 100);
68 
69         msg.sender.transfer(excessMoney);
70     }
71 
72     function bmc(uint ci_, uint c_, address ref_) public payable {
73         require(di.gcp(ci_) > 0);
74 
75         uint cmp_ = di.gcmp(ci_, c_);
76         cmp_ = cmp_ * pf(msg.sender)/10000;
77         require(msg.value >= cmp_);
78 
79         uint excessMoney = msg.value - cmp_;
80             
81 
82 
83         di.cmpn(ci_, c_);
84         di.ico(ci_, msg.sender, c_);
85 
86         di.ap(msg.sender);
87         di.rb(msg.sender);
88 
89         EventBmc(msg.sender, ci_, c_);
90 
91         address rr = di.gur(msg.sender, ref_);
92         if(rr != address(0)) {
93             uint rrb = cmp_ * rb / 100;
94             di.irbg(rr, rrb);
95             rr.transfer(rrb);
96         }
97         msg.sender.transfer(excessMoney);
98     }
99     
100     function cg() public {
101         di.cg(msg.sender, GPC, MG, GC);
102         di.ap(msg.sender);
103         EventCg(msg.sender);
104     }
105 
106     function pf(address u_) public view returns (uint c) {
107         c = 10000;
108         if(!di.guhb(u_)) {
109             c = c * (100 - npb) / 100;
110         }
111         uint _gc = di.ggc(u_);
112         if(_gc > 0) {
113             c = c * (100 - _gc) / 100;
114         }
115     }
116 
117     function cd1(address x_) public view returns (uint _gc, uint _gcd, bool _uhb, uint _npb, uint _ggcd, uint _mg, uint _gpc, uint _rb, uint _rg) {
118         _gc = di.ggc(x_);
119         _gcd = di.ggcd(x_);
120         _uhb = di.guhb(x_);
121         _npb = npb;
122         _ggcd = GC;
123         _mg = MG;
124         _gpc = GPC;
125         _rb = rb;
126         _rg = di.grg(x_);
127     }
128     function cd() public view returns (uint _gc, uint _gcd, bool _uhb, uint _npb, uint _ggcd, uint _mg, uint _gpc, uint _rb, uint _rg) {
129         return cd1(msg.sender);
130     }
131     function gcard(uint ci_, address co_) public view returns (uint _coc, uint _csc, uint _cp, uint _cpn, uint _cpm, uint _cpa, uint _csp) {
132         _coc = di.gco(ci_, co_);
133         _csc = di.gcsc(ci_);
134         _cp = di.gcp(ci_);
135         _cpn = di.gcpn(ci_);
136         _cpm = di.gcpm(ci_);
137         _cpa = di.gcpa(ci_);
138         _csp = di.gcsp(ci_);
139     }
140 
141 
142     function sc(uint ci_, uint csp_, uint cpm_, uint cpa_, uint csc_) public onlyOp {
143         di.sc(ci_, csp_, cpm_, cpa_, csc_);
144     }
145     function srb(uint rb_) external onlyOp {
146         rb = rb_;
147     }
148     function sgc(uint GC_) public onlyOp {
149         GC = GC_;
150     }
151     function smg(uint MG_) public onlyOp {
152         MG = MG_;
153     }   
154     function sgpc(uint GPC_) public onlyOp {
155         GPC = GPC_;
156     }    
157     function snpb(uint npb_) public onlyOp {
158         npb = npb_;
159     }
160 
161     function payout(address to_) public onlyOp {
162         payoutX(to_, this.balance);
163     }
164     function payoutX(address to_, uint value_) public onlyOp {
165         require(address(0) != to_);
166         if(value_ > this.balance)
167             to_.transfer(this.balance);
168         else
169             to_.transfer(value_);
170     }
171 
172     function sdc(address dc_) public onlyOp {
173         if(dc_ != address(0))
174             di = DI(dc_);
175     }
176     modifier onlyOp() {
177         require(msg.sender == opAddr);
178         _;
179     }
180     function setOp(address newOpAddr_) public onlyOp {
181         require(newOpAddr_ != address(0));
182         newOpAddr = newOpAddr_;
183     }
184     function acceptOp() public {
185         require(msg.sender == newOpAddr);
186         require(address(0) != newOpAddr);
187         opAddr = newOpAddr;
188         newOpAddr = address(0);
189     }
190 }