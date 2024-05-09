1 pragma solidity ^0.4.11;
2 
3 contract ERC223 {
4     function tokenFallback(address _from, uint _value, bytes _data) public {}
5 }
6 
7 library SafeMath {
8     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
9         assert(b <= a);
10         return a - b;
11     }
12     function add(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a + b;
14         assert(c >= a);
15         return c;
16     }
17 }
18 
19 contract EtheraffleFreeLOT is ERC223 {
20     using SafeMath for uint;
21 
22     string    public name;
23     string    public symbol;
24     address[] public minters;
25     uint      public redeemed;
26     uint8     public decimals;
27     address[] public destroyers;
28     address   public etheraffle;
29     uint      public totalSupply;
30 
31     mapping (address => uint) public balances;
32     mapping (address => bool) public isMinter;
33     mapping (address => bool) public isDestroyer;
34 
35 
36     event LogMinterAddition(address newMinter, uint atTime);
37     event LogMinterRemoval(address minterRemoved, uint atTime);
38     event LogDestroyerAddition(address newDestroyer, uint atTime);
39     event LogDestroyerRemoval(address destroyerRemoved, uint atTime);
40     event LogMinting(address indexed toWhom, uint amountMinted, uint atTime);
41     event LogDestruction(address indexed toWhom, uint amountDestroyed, uint atTime);
42     event LogEtheraffleChange(address prevController, address newController, uint atTime);
43     event LogTransfer(address indexed from, address indexed to, uint value, bytes indexed data);
44     /**
45      * @dev   Modifier function to prepend to methods rendering them only callable
46      *        by the Etheraffle MultiSig wallet.
47      */
48     modifier onlyEtheraffle() {
49         require(msg.sender == etheraffle);
50         _;
51     }
52     /**
53      * @dev   Constructor: Sets the meta data & controller for the token.
54      *
55      * @param _etheraffle   The Etheraffle multisig wallet.
56      * @param _amt          Amount to mint on contract creation.
57      */
58     function EtheraffleFreeLOT(address _etheraffle, uint _amt) {
59         name       = "Etheraffle FreeLOT";
60         symbol     = "FreeLOT";
61         etheraffle = _etheraffle;
62         minters.push(_etheraffle);
63         destroyers.push(_etheraffle);
64         totalSupply              = _amt;
65         balances[_etheraffle]    = _amt;
66         isMinter[_etheraffle]    = true;
67         isDestroyer[_etheraffle] = true;
68     }
69     /**
70      * ERC223 Standard functions:
71      *
72      * @dev Transfer the specified amount of FreeLOT to the specified address.
73      *      Invokes the tokenFallback function if the recipient is a contract.
74      *      The token transfer fails if the recipient is a contract but does not
75      *      implement the tokenFallback function.
76      *
77      * @param _to     Receiver address.
78      * @param _value  Amount of FreeLOT to be transferred.
79      * @param _data   Transaction metadata.
80      */
81     function transfer(address _to, uint _value, bytes _data) external {
82         uint codeLength;
83         assembly {
84             codeLength := extcodesize(_to)
85         }
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to]        = balances[_to].add(_value);
88         if(codeLength > 0) {
89             ERC223 receiver = ERC223(_to);
90             receiver.tokenFallback(msg.sender, _value, _data);
91         }
92         LogTransfer(msg.sender, _to, _value, _data);
93     }
94     /**
95      * @dev     Transfer the specified amount of FreeLOT to the specified address.
96      *          Standard function transfer similar to ERC20 transfer with no
97      *          _data param. Added due to backwards compatibility reasons.
98      *
99      * @param _to     Receiver address.
100      * @param _value  Amount of FreeLOT to be transferred.
101      */
102     function transfer(address _to, uint _value) external {
103         uint codeLength;
104         bytes memory empty;
105         assembly {
106             codeLength := extcodesize(_to)
107         }
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to]        = balances[_to].add(_value);
110         if(codeLength > 0) {
111             ERC223 receiver = ERC223(_to);
112             receiver.tokenFallback(msg.sender, _value, empty);
113         }
114         LogTransfer(msg.sender, _to, _value, empty);
115     }
116     /**
117      * @dev     Returns balance of a queried address.
118      * @param _owner    The address whose balance will be returned.
119      * @return balance  Balance of the of the queried address.
120      */
121     function balanceOf(address _owner) constant external returns (uint balance) {
122         return balances[_owner];
123     }
124     /**
125      * @dev     Allow changing of contract ownership ready for future upgrades/
126      *          changes in management structure.
127      *
128      * @param _new  New owner/controller address.
129      */
130     function setEtheraffle(address _new) external onlyEtheraffle {
131         LogEtheraffleChange(etheraffle, _new, now);
132         etheraffle = _new;
133     }
134     /**
135      * @dev     Allow addition of minters to allow future contracts to
136      *          use the role.
137      *
138      * @param _new  New minter address.
139      */
140     function addMinter(address _new) external onlyEtheraffle {
141         minters.push(_new);
142         isMinter[_new] = true;
143         LogMinterAddition(_new, now);
144     }
145     /**
146      * @dev     Remove a minter should they no longer require or need the
147      *          the privilege.
148      *
149      * @param _minter    The desired address to be removed.
150      */
151     function removeMinter(address _minter) external onlyEtheraffle {
152         require(isMinter[_minter]);
153         isMinter[_minter] = false;
154         for(uint i = 0; i < minters.length - 1; i++)
155             if(minters[i] == _minter) {
156                 minters[i] = minters[minters.length - 1];
157                 break;
158             }
159         minters.length--;
160         LogMinterRemoval(_minter, now);
161     }
162     /**
163      * @dev     Allow addition of a destroyer to allow future contracts to
164      *          use the role.
165      *
166      * @param _new  New destroyer address.
167      */
168     function addDestroyer(address _new) external onlyEtheraffle {
169         destroyers.push(_new);
170         isDestroyer[_new] = true;
171         LogDestroyerAddition(_new, now);
172     }
173     /**
174      * @dev     Remove a destroyer should they no longer require or need the
175      *          the privilege.
176      *
177      * @param _destroyer    The desired address to be removed.
178      */
179     function removeDestroyer(address _destroyer) external onlyEtheraffle {
180         require(isDestroyer[_destroyer]);
181         isDestroyer[_destroyer] = false;
182         for(uint i = 0; i < destroyers.length - 1; i++)
183             if(destroyers[i] == _destroyer) {
184                 destroyers[i] = destroyers[destroyers.length - 1];
185                 break;
186             }
187         destroyers.length--;
188         LogDestroyerRemoval(_destroyer, now);
189     }
190     /**
191      * @dev    This function mints tokens by adding tokens to the total supply
192      *         and assigning them to the given address.
193      *
194      * @param _to      The address recipient of the minted tokens.
195      * @param _amt     The amount of tokens to mint & assign.
196      */
197     function mint(address _to, uint _amt) external {
198         require(isMinter[msg.sender]);
199         totalSupply   = totalSupply.add(_amt);
200         balances[_to] = balances[_to].add(_amt);
201         LogMinting(_to, _amt, now);
202     }
203     /**
204      * @dev    This function destroys tokens by subtracting them from the total
205      *         supply and removing them from the given address. Increments the
206      *         redeemed variable to track the number of "used" tokens. Only
207      *         callable by the Etheraffle multisig or a designated destroyer.
208      *
209      * @param _from    The address from whom the token is destroyed.
210      * @param _amt     The amount of tokens to destroy.
211      */
212     function destroy(address _from, uint _amt) external {
213         require(isDestroyer[msg.sender]);
214         totalSupply     = totalSupply.sub(_amt);
215         balances[_from] = balances[_from].sub(_amt);
216         redeemed++;
217         LogDestruction(_from, _amt, now);
218     }
219     /**
220      * @dev   Housekeeping- called in the event this contract is no
221      *        longer needed. Deletes the code from the blockchain.
222      *        Only callable by the Etheraffle address.
223      */
224     function selfDestruct() external onlyEtheraffle {
225         selfdestruct(etheraffle);
226     }
227     /**
228      * @dev   Fallback in case of accidental ether transfer
229      */
230     function () external payable {
231         revert();
232     }
233 }