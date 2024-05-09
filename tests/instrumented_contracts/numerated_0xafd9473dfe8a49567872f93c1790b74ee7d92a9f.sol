1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
5         assert(b <= a);
6         return a - b;
7     }
8     function add(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a + b;
10         assert(c >= a);
11         return c;
12     }
13 }
14 
15 contract ERC223Compliant {
16     function tokenFallback(address _from, uint _value, bytes _data) {}
17 }
18 
19 contract EtheraffleLOT is ERC223Compliant {
20     using SafeMath for uint;
21 
22     string    public name;
23     string    public symbol;
24     bool      public frozen;
25     uint8     public decimals;
26     address[] public freezers;
27     address   public etheraffle;
28     uint      public totalSupply;
29 
30     mapping (address => uint) public balances;
31     mapping (address => bool) public canFreeze;
32 
33     event LogFrozenStatus(bool status, uint atTime);
34     event LogFreezerAddition(address newFreezer, uint atTime);
35     event LogFreezerRemoval(address freezerRemoved, uint atTime);
36     event LogEtheraffleChange(address prevER, address newER, uint atTime);
37     event LogTransfer(address indexed from, address indexed to, uint value, bytes indexed data);
38 
39     /**
40      * @dev   Modifier function to prepend to methods rendering them only callable
41      *        by the Etheraffle MultiSig wallet.
42      */
43     modifier onlyEtheraffle() {
44         require(msg.sender == etheraffle);
45         _;
46     }
47     /**
48      * @dev   Modifier function to prepend to methods rendering them only callable
49      *        by address approved for freezing.
50      */
51     modifier onlyFreezers() {
52         require(canFreeze[msg.sender]);
53         _;
54     }
55     /**
56      * @dev   Modifier function to prepend to methods to render them only callable
57      *        when the frozen toggle is false
58      */
59     modifier onlyIfNotFrozen() {
60         require(!frozen);
61         _;
62     }
63     /**
64      * @dev   Constructor: Sets the meta data for the token and gives the intial supply to the
65      *        Etheraffle ICO.
66      *
67      * @param _etheraffle   Address of the Etheraffle's multisig wallet, the only
68      *                      address via which the frozen/unfrozen state of the
69      *                      token transfers can be toggled.
70      * @param _supply       Total numner of LOT to mint on contract creation.
71 
72      */
73     function EtheraffleLOT(address _etheraffle, uint _supply) {
74         freezers.push(_etheraffle);
75         name                   = "Etheraffle LOT";
76         symbol                 = "LOT";
77         decimals               = 6;
78         etheraffle             = _etheraffle;
79         totalSupply            = _supply * 10 ** uint256(decimals);
80         balances[_etheraffle]  = totalSupply;
81         canFreeze[_etheraffle] = true;
82     }
83     /**
84      * ERC223 Standard functions:
85      *
86      * @dev Transfer the specified amount of LOT to the specified address.
87      *      Invokes the `tokenFallback` function if the recipient is a contract.
88      *      The token transfer fails if the recipient is a contract
89      *      but does not implement the `tokenFallback` function
90      *      or the fallback function to receive funds.
91      *
92      * @param _to     Receiver address.
93      * @param _value  Amount of LOT to be transferred.
94      * @param _data   Transaction metadata.
95      */
96     function transfer(address _to, uint _value, bytes _data) onlyIfNotFrozen external {
97         uint codeLength;
98         assembly {
99             codeLength := extcodesize(_to)
100         }
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to]        = balances[_to].add(_value);
103         if(codeLength > 0) {
104             ERC223Compliant receiver = ERC223Compliant(_to);
105             receiver.tokenFallback(msg.sender, _value, _data);
106         }
107         LogTransfer(msg.sender, _to, _value, _data);
108     }
109     /**
110      * @dev   Transfer the specified amount of LOT to the specified address.
111      *        Standard function transfer similar to ERC20 transfer with no
112      *        _data param. Added due to backwards compatibility reasons.
113      *
114      * @param _to     Receiver address.
115      * @param _value  Amount of LOT to be transferred.
116      */
117     function transfer(address _to, uint _value) onlyIfNotFrozen external {
118         uint codeLength;
119         bytes memory empty;
120         assembly {
121             codeLength := extcodesize(_to)
122         }
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to]        = balances[_to].add(_value);
125         if(codeLength > 0) {
126             ERC223Compliant receiver = ERC223Compliant(_to);
127             receiver.tokenFallback(msg.sender, _value, empty);
128         }
129         LogTransfer(msg.sender, _to, _value, empty);
130     }
131     /**
132      * @dev     Returns balance of the `_owner`.
133      * @param _owner    The address whose balance will be returned.
134      * @return balance  Balance of the `_owner`.
135      */
136     function balanceOf(address _owner) constant external returns (uint balance) {
137         return balances[_owner];
138     }
139     /**
140      * @dev   Change the frozen status of the LOT token.
141      *
142      * @param _status   Desired status of the frozen bool
143      */
144     function setFrozen(bool _status) external onlyFreezers returns (bool) {
145         frozen = _status;
146         LogFrozenStatus(frozen, now);
147         return frozen;
148     }
149     /**
150      * @dev     Allow addition of freezers to allow future contracts to
151      *          use the role.
152      *
153      * @param _new  New freezer address.
154      */
155     function addFreezer(address _new) external onlyEtheraffle {
156         freezers.push(_new);
157         canFreeze[_new] = true;
158         LogFreezerAddition(_new, now);
159     }
160     /**
161      * @dev     Remove a freezer should they no longer require or need the
162      *          the privilege.
163      *
164      * @param _freezer    The desired address to be removed.
165      */
166     function removeFreezer(address _freezer) external onlyEtheraffle {
167         require(canFreeze[_freezer]);
168         canFreeze[_freezer] = false;
169         for(uint i = 0; i < freezers.length - 1; i++)
170             if(freezers[i] == _freezer) {
171                 freezers[i] = freezers[freezers.length - 1];
172                 break;
173             }
174         freezers.length--;
175         LogFreezerRemoval(_freezer, now);
176     }
177     /**
178      * @dev   Allow changing of contract ownership ready for future upgrades/
179      *        changes in management structure.
180      *
181      * @param _new  New owner/controller address.
182      */
183     function setEtheraffle(address _new) external onlyEtheraffle {
184         LogEtheraffleChange(etheraffle, _new, now);
185         etheraffle = _new;
186     }
187     /**
188      * @dev   Fallback in case of accidental ether transfer
189      */
190     function () external payable {
191         revert();
192     }
193     /**
194      * @dev   Housekeeping- called in the event this contract is no
195      *        longer needed, after a LOT upgrade for example. Deletes
196      *        the code from the blockchain. Only callable by the
197      *        Etheraffle address.
198      */
199     function selfDestruct() external onlyEtheraffle {
200         require(frozen);
201         selfdestruct(etheraffle);
202     }
203 }