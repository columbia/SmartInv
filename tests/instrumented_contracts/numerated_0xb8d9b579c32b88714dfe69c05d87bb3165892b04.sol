1 pragma solidity ^0.4.16;
2 
3 contract BachelorBucks {
4     string public standard = 'BBUCK 1.0';
5     string public name = 'BachelorBucks';
6     string public symbol = 'BBUCK';
7     uint8 public decimals = 0;
8     uint256 public totalSupply = 1000000000;
9     uint256 public initialPrice = 1 ether / 1000;
10     uint256 public priceIncreasePerPurchase = 1 ether / 100000;
11     uint256 public currentPrice = initialPrice;
12     
13     address public owner = msg.sender;
14     uint256 public creationTime = now;
15     
16     struct Component {
17         string name;
18         uint16 index;
19         int256 currentSupport;
20         uint256 supported;
21         uint256 undermined;
22     }
23     
24     struct AddOn {
25         string name;
26         uint16 index;
27         uint256 support;
28         uint256 threshold;
29         bool completed;
30         address winner;
31     }
32     
33     struct Wildcard {
34         string name;
35         uint16 index;
36         uint256 cost;
37         uint16 available;
38     }
39     
40     /* Creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     mapping (address => mapping (address => uint256)) public allowance;
43     
44     uint16 public componentCount = 0;
45     mapping (uint16 => Component) public components;
46     
47     uint16 public addOnCount = 0;
48     mapping (uint16 => AddOn) public addOns;
49     
50     uint16 public wildcardCount = 0;
51     mapping (uint16 => Wildcard) public wildcards;
52     mapping (address => mapping (uint16 => uint16)) public wildcardsHeld;
53 
54     /* Generates a public event on the blockchain that will notify clients of transfers */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     
57     /* Generates a public event on the blockchain that will notify clients of purchases */
58     event Purchase(address indexed from, uint256 value);
59 
60     /* Notifies clients about support for a component */
61     event SupportComponent(uint256 componentIdx, address indexed from, uint256 value);
62     
63     /* Notifies clients about undermine for a component */
64     event UndermineComponent(uint256 componentIdx, address indexed from, uint256 value);
65     
66     /* Notifies clients about support for an addOn */
67     event SupportAddOn(uint256 addOnIdx, address indexed from, uint256 value);
68     
69     /* Notifies clients about completion for an addOn */
70     event CompleteAddOn(uint256 addOnIdx, address indexed winner);
71 
72     /* Notifies clients about wildcard completion */
73     event CompleteWildcard(uint256 wildcardIdx, address indexed caller);
74 
75     modifier onlyByOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79     
80     modifier neverByOwner() {
81         require(msg.sender != owner);
82         _;
83     }
84     
85     /* Initializes contract with initial supply tokens to me */
86     function BachelorBucks() public {
87         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
88     }
89     
90     function createComponent(string componentName) public onlyByOwner() returns (bool success) {
91         if (componentCount > 65534) revert();
92         var component = components[componentCount];
93         component.name = componentName;
94         component.index = componentCount;
95         component.currentSupport = 0;
96         component.supported = 0;
97         component.undermined = 0;
98         componentCount += 1;
99         return true;
100     }
101     
102     function createAddOn(string addOnName, uint256 threshold) public onlyByOwner() returns (bool success) {
103         if (addOnCount > 65534) revert();
104         if (threshold == 0) revert();
105         var addOn = addOns[addOnCount];
106         addOn.name = addOnName;
107         addOn.index = addOnCount;
108         addOn.support = 0;
109         addOn.threshold = threshold;
110         addOn.completed = false;
111         addOn.winner = address(0x0);
112         addOnCount += 1;
113         return true;
114     }
115     
116     function createWildcard(string wildcardName, uint256 cost, uint16 number) public onlyByOwner() returns (bool success) {
117         if (wildcardCount > 65534) revert();
118         if (number == 0) revert();
119         if (cost == 0) revert();
120         var wildcard = wildcards[wildcardCount];
121         wildcard.name = wildcardName;
122         wildcard.index = wildcardCount;
123         wildcard.available = number;
124         wildcard.cost = cost;
125         wildcardCount += 1;
126         return true;
127     }
128     
129     function giveMeSomeBBUCKs() public payable returns (bool success) {
130         if (msg.value < currentPrice) revert();
131         uint256 amount = (msg.value / currentPrice);
132         if (balanceOf[owner] < amount) revert();
133         balanceOf[owner] -= amount;
134         balanceOf[msg.sender] += amount;
135         if ((currentPrice + priceIncreasePerPurchase) < currentPrice) return true; // Maximum price reached
136         currentPrice += priceIncreasePerPurchase;
137         return true;
138     }
139     
140     function() public payable { }                               // Thanks for the donation!
141     
142     function getBalance() view public returns (uint256) {
143         return balanceOf[msg.sender];
144     }
145     
146     function sweepToOwner() public onlyByOwner() returns (bool success) {
147         owner.transfer(this.balance);
148         return true;
149     }
150     
151     /* Send coins */
152     function transfer(address _to, uint256 _value) public {
153         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address
154         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
155         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
156         balanceOf[msg.sender] -= _value;                        // Subtract from the sender
157         balanceOf[_to] += _value;                               // Add the same to the recipient
158         Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
159     }
160 
161     /* Allow another contract to spend some tokens on my behalf */
162     function approve(address _spender, uint256 _value) public returns (bool success) {
163         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
164         allowance[msg.sender][_spender] = _value;
165         return true;
166     }
167 
168     /* A contract attempts to get the coins */
169     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
170         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address
171         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
172         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
173         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
174         balanceOf[_from] -= _value;                              // Subtract from the sender
175         balanceOf[_to] += _value;                                // Add the same to the recipient
176         allowance[_from][msg.sender] -= _value;
177         Transfer(_from, _to, _value);
178         return true;
179     }
180 
181 	/* Add support a component */
182     function supportComponent(uint16 component_idx, uint256 value) public neverByOwner() returns (bool success) {
183         if (value == 0) revert();                                       // Can't add 0 support
184         if (balanceOf[msg.sender] < value) revert();                    // Check if the sender has enough
185         if (component_idx >= componentCount) revert();                  // Check if the component index is valid
186         var component = components[component_idx];
187         if ((component.supported + value) < component.supported) revert();                    // Will adding support wrap the supported counter
188         if ((component.currentSupport + int256(value)) < component.currentSupport) revert();  // Will adding this much support wrap the component support
189         balanceOf[msg.sender] -= value;                                 // Subtract from the sender
190         component.currentSupport += int256(value);                      // Add support to the component
191         component.supported += value;
192         totalSupply -= value;                                           // Remove value from the totalSupply
193         SupportComponent(component_idx, msg.sender, value);
194         return true;
195     }
196     
197   /* Undermine support for a component */
198     function undermineComponent(uint16 component_idx, uint256 value) public neverByOwner() returns (bool success) {
199         if (value == 0) revert();                                       // Can't subtract 0 support
200         if (balanceOf[msg.sender] < value) revert();                    // Check if the sender has enough
201         if (component_idx >= componentCount) revert();                  // Check if the component index is valid
202         var component = components[component_idx];
203         if ((component.currentSupport - int256(value)) > component.currentSupport) revert();  // Will subtracting this much support wrap the component support
204         balanceOf[msg.sender] -= value;                                 // Subtract from the sender
205         component.currentSupport -= int256(value);                      // Subtract support from the component
206         component.undermined += value;
207         totalSupply -= value;                                           // Remove value from the totalSupply
208         UndermineComponent(component_idx, msg.sender, value);
209         return true;
210     }
211 
212 	/* Get current component support */
213     function getComponentSupport(uint16 component_idx) view public returns (int256) {
214         if (component_idx >= componentCount) return 0;
215         return components[component_idx].currentSupport;
216     }
217     
218     /* Add support an addOn */
219     function supportAddOn(uint16 addOn_idx, uint256 value) public neverByOwner() returns (bool success) {
220         if (value == 0) revert();                                       // Can't add 0 support
221         if (balanceOf[msg.sender] < value) revert();                    // Check if the sender has enough
222         if (addOn_idx >= addOnCount) revert();                          // Check if the addon index is valid
223         var addOn = addOns[addOn_idx];
224         if (addOn.completed) revert();
225         if ((addOn.support + value) < addOn.support) revert();          // Will adding support wrap the support counter
226         balanceOf[msg.sender] -= value;                                 // Subtract from the sender
227         addOn.support += value;                                         // Add support to the component
228         totalSupply -= value;                                           // Remove value from the totalSupply
229         SupportAddOn(addOn_idx, msg.sender, value);
230         if (addOn.support < addOn.threshold) return true;              // Threshold is not yet met
231         addOn.completed = true;
232         addOn.winner = msg.sender;
233         CompleteAddOn(addOn_idx, addOn.winner);
234         return true;
235     }
236     
237     /* Get current addOn support */
238     function getAddOnSupport(uint16 addOn_idx) view public returns (uint256) {
239         if (addOn_idx >= addOnCount) return 0;
240         return addOns[addOn_idx].support;
241     }
242     
243     /* Get current addOn support */
244     function getAddOnNeeded(uint16 addOn_idx) view public returns (uint256) {
245         if (addOn_idx >= addOnCount) return 0;
246         var addOn = addOns[addOn_idx];
247         if (addOn.completed) return 0;
248         return addOn.threshold - addOn.support;
249     }
250     
251     /* Get current addOn support */
252     function getAddOnComplete(uint16 addOn_idx) view public returns (bool) {
253         if (addOn_idx >= addOnCount) return false;
254         return addOns[addOn_idx].completed;
255     }
256     
257     /* acquire a wildcard */
258     function acquireWildcard(uint16 wildcard_idx) public neverByOwner() returns (bool success) {
259         if (wildcard_idx >= wildcardCount) revert();                    // Check if the wildcard index is valid
260         var wildcard = wildcards[wildcard_idx];
261         if (balanceOf[msg.sender] < wildcard.cost) revert();            // Check if the sender has enough
262         if (wildcard.available < 1) revert();                           // Are there wildcards still available
263         balanceOf[msg.sender] -= wildcard.cost;                         // Subtract from the sender
264         wildcard.available -= 1;                                        // Subtract 1 wildcard from the deck
265         totalSupply -= wildcard.cost;                                   // Remove value from the totalSupply
266         wildcardsHeld[msg.sender][wildcard_idx] += 1;
267         CompleteWildcard(wildcard_idx, msg.sender);
268         return true;
269     }
270     
271     /* Get remaining wildcards */
272     function getWildcardsRemaining(uint16 wildcard_idx) view public returns (uint16) {
273         if (wildcard_idx >= wildcardCount) return 0;
274         return wildcards[wildcard_idx].available;
275     }
276 }