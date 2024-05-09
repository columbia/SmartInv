1 // hevm: flattened sources of /nix/store/nrmi9gk7q94ba1fbhq9bphlbpqd1y8hw-scd-mcd-migration-e730e63/src/ScdMcdMigration.sol
2 pragma solidity =0.5.12;
3 
4 ////// /nix/store/nrmi9gk7q94ba1fbhq9bphlbpqd1y8hw-scd-mcd-migration-e730e63/src/Interfaces.sol
5 /* pragma solidity 0.5.12; */
6 
7 contract GemLike {
8     function allowance(address, address) public returns (uint);
9     function approve(address, uint) public;
10     function transfer(address, uint) public returns (bool);
11     function transferFrom(address, address, uint) public returns (bool);
12 }
13 
14 contract ValueLike {
15     function peek() public returns (uint, bool);
16 }
17 
18 contract SaiTubLike {
19     function skr() public view returns (GemLike);
20     function gem() public view returns (GemLike);
21     function gov() public view returns (GemLike);
22     function sai() public view returns (GemLike);
23     function pep() public view returns (ValueLike);
24     function vox() public view returns (VoxLike);
25     function bid(uint) public view returns (uint);
26     function ink(bytes32) public view returns (uint);
27     function tag() public view returns (uint);
28     function tab(bytes32) public returns (uint);
29     function rap(bytes32) public returns (uint);
30     function draw(bytes32, uint) public;
31     function shut(bytes32) public;
32     function exit(uint) public;
33     function give(bytes32, address) public;
34 }
35 
36 contract VoxLike {
37     function par() public returns (uint);
38 }
39 
40 contract JoinLike {
41     function ilk() public returns (bytes32);
42     function gem() public returns (GemLike);
43     function dai() public returns (GemLike);
44     function join(address, uint) public;
45     function exit(address, uint) public;
46 }
47 contract VatLike {
48     function ilks(bytes32) public view returns (uint, uint, uint, uint, uint);
49     function hope(address) public;
50     function frob(bytes32, address, address, address, int, int) public;
51 }
52 
53 contract ManagerLike {
54     function vat() public view returns (address);
55     function urns(uint) public view returns (address);
56     function open(bytes32, address) public returns (uint);
57     function frob(uint, int, int) public;
58     function give(uint, address) public;
59     function move(uint, address, uint) public;
60 }
61 
62 contract OtcLike {
63     function getPayAmount(address, address, uint) public view returns (uint);
64     function buyAllAmount(address, uint, address, uint) public;
65 }
66 
67 ////// /nix/store/nrmi9gk7q94ba1fbhq9bphlbpqd1y8hw-scd-mcd-migration-e730e63/src/ScdMcdMigration.sol
68 /* pragma solidity 0.5.12; */
69 
70 /* import { JoinLike, ManagerLike, SaiTubLike, VatLike } from "./Interfaces.sol"; */
71 
72 contract ScdMcdMigration {
73     SaiTubLike                  public tub;
74     VatLike                     public vat;
75     ManagerLike                 public cdpManager;
76     JoinLike                    public saiJoin;
77     JoinLike                    public wethJoin;
78     JoinLike                    public daiJoin;
79 
80     constructor(
81         address tub_,           // SCD tub contract address
82         address cdpManager_,    // MCD manager contract address
83         address saiJoin_,       // MCD SAI collateral adapter contract address
84         address wethJoin_,      // MCD ETH collateral adapter contract address
85         address daiJoin_        // MCD DAI adapter contract address
86     ) public {
87         tub = SaiTubLike(tub_);
88         cdpManager = ManagerLike(cdpManager_);
89         vat = VatLike(cdpManager.vat());
90         saiJoin = JoinLike(saiJoin_);
91         wethJoin = JoinLike(wethJoin_);
92         daiJoin = JoinLike(daiJoin_);
93 
94         require(wethJoin.gem() == tub.gem(), "non-matching-weth");
95         require(saiJoin.gem() == tub.sai(), "non-matching-sai");
96 
97         tub.gov().approve(address(tub), uint(-1));
98         tub.skr().approve(address(tub), uint(-1));
99         tub.sai().approve(address(tub), uint(-1));
100         tub.sai().approve(address(saiJoin), uint(-1));
101         wethJoin.gem().approve(address(wethJoin), uint(-1));
102         daiJoin.dai().approve(address(daiJoin), uint(-1));
103         vat.hope(address(daiJoin));
104     }
105 
106     function add(uint x, uint y) internal pure returns (uint z) {
107         require((z = x + y) >= x, "add-overflow");
108     }
109 
110     function sub(uint x, uint y) internal pure returns (uint z) {
111         require((z = x - y) <= x, "sub-underflow");
112     }
113 
114     function mul(uint x, uint y) internal pure returns (uint z) {
115         require(y == 0 || (z = x * y) / y == x, "mul-overflow");
116     }
117 
118     function toInt(uint x) internal pure returns (int y) {
119         y = int(x);
120         require(y >= 0, "int-overflow");
121     }
122 
123     // Function to swap SAI to DAI
124     // This function is to be used by users that want to get new DAI in exchange of old one (aka SAI)
125     // wad amount has to be <= the value pending to reach the debt ceiling (the minimum between general and ilk one)
126     function swapSaiToDai(
127         uint wad
128     ) external {
129         // Get wad amount of SAI from user's wallet:
130         saiJoin.gem().transferFrom(msg.sender, address(this), wad);
131         // Join the SAI wad amount to the `vat`:
132         saiJoin.join(address(this), wad);
133         // Lock the SAI wad amount to the CDP and generate the same wad amount of DAI
134         vat.frob(saiJoin.ilk(), address(this), address(this), address(this), toInt(wad), toInt(wad));
135         // Send DAI wad amount as a ERC20 token to the user's wallet
136         daiJoin.exit(msg.sender, wad);
137     }
138 
139     // Function to swap DAI to SAI
140     // This function is to be used by users that want to get SAI in exchange of DAI
141     // wad amount has to be <= the amount of SAI locked (and DAI generated) in the migration contract SAI CDP
142     function swapDaiToSai(
143         uint wad
144     ) external {
145         // Get wad amount of DAI from user's wallet:
146         daiJoin.dai().transferFrom(msg.sender, address(this), wad);
147         // Join the DAI wad amount to the vat:
148         daiJoin.join(address(this), wad);
149         // Payback the DAI wad amount and unlocks the same value of SAI collateral
150         vat.frob(saiJoin.ilk(), address(this), address(this), address(this), -toInt(wad), -toInt(wad));
151         // Send SAI wad amount as a ERC20 token to the user's wallet
152         saiJoin.exit(msg.sender, wad);
153     }
154 
155     // Function to migrate a SCD CDP to MCD one (needs to be used via a proxy so the code can be kept simpler). Check MigrationProxyActions.sol code for usage.
156     // In order to use migrate function, SCD CDP debtAmt needs to be <= SAI previously deposited in the SAI CDP * (100% - Collateralization Ratio)
157     function migrate(
158         bytes32 cup
159     ) external returns (uint cdp) {
160         // Get values
161         uint debtAmt = tub.tab(cup);    // CDP SAI debt
162         uint pethAmt = tub.ink(cup);    // CDP locked collateral
163         uint ethAmt = tub.bid(pethAmt); // CDP locked collateral equiv in ETH
164 
165         // Take SAI out from MCD SAI CDP. For this operation is necessary to have a very low collateralization ratio
166         // This is not actually a problem as this ilk will only be accessed by this migration contract,
167         // which will make sure to have the amounts balanced out at the end of the execution.
168         vat.frob(
169             bytes32(saiJoin.ilk()),
170             address(this),
171             address(this),
172             address(this),
173             -toInt(debtAmt),
174             0
175         );
176         saiJoin.exit(address(this), debtAmt); // SAI is exited as a token
177 
178         // Shut SAI CDP and gets WETH back
179         tub.shut(cup);      // CDP is closed using the SAI just exited and the MKR previously sent by the user (via the proxy call)
180         tub.exit(pethAmt);  // Converts PETH to WETH
181 
182         // Open future user's CDP in MCD
183         cdp = cdpManager.open(wethJoin.ilk(), address(this));
184 
185         // Join WETH to Adapter
186         wethJoin.join(cdpManager.urns(cdp), ethAmt);
187 
188         // Lock WETH in future user's CDP and generate debt to compensate the SAI used to paid the SCD CDP
189         (, uint rate,,,) = vat.ilks(wethJoin.ilk());
190         cdpManager.frob(
191             cdp,
192             toInt(ethAmt),
193             toInt(mul(debtAmt, 10 ** 27) / rate + 1) // To avoid rounding issues we add an extra wei of debt
194         );
195         // Move DAI generated to migration contract (to recover the used funds)
196         cdpManager.move(cdp, address(this), mul(debtAmt, 10 ** 27));
197         // Re-balance MCD SAI migration contract's CDP
198         vat.frob(
199             bytes32(saiJoin.ilk()),
200             address(this),
201             address(this),
202             address(this),
203             0,
204             -toInt(debtAmt)
205         );
206 
207         // Set ownership of CDP to the user
208         cdpManager.give(cdp, msg.sender);
209     }
210 }