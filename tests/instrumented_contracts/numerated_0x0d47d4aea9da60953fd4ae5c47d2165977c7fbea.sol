1 /// @title The main smart contract for Etherprises LLC, Delaware, U.S. (c)2017 Etherprises LLC
2 /// @author Ville Sundell <contact@etherprises.com>
3 // This source code is available at https://etherscan.io/address/0x0d47d4aea9da60953fd4ae5c47d2165977c7fbea
4 // This code (and only this source code, not storage data nor other information/data) is released under CC-0.
5 // More source regarding Etherprises LLC can be found at: https://github.com/Etherprises
6 // The legal prose amending the contract between your series and Etherprises LLC is defined in prose() as a string array
7 
8 pragma solidity ^0.4.9;
9 
10 //This is the main contract, this handles series creation and renewal:
11 contract EtherprisesLLC {
12     //This factory will create the series smart contract:
13     address public seriesFactory;
14     //This is the address of the only member or the series organization:
15     address public generalManager;
16     //List of series addresses, this is the main index:
17     address[] public series;
18     //Listing amendments as a legal prose, starting from 0:
19     string[] public prose;
20     //This map makes routing funds to user's latest series easy and fast:
21     mapping (address => address) public latestSeriesForUser;
22     //Series' expiring date is specified here as UNIX timestamp:
23     mapping (address => uint) public expiresAt;
24     //This maps series' name to an address
25     mapping (bytes32 => address) public seriesByName;
26     //This maps series' address to a name
27     mapping (address => bytes32) public seriesByAddress;
28     
29     //Events for external monitoring:
30     event AmendmentAdded (string newAmendment);
31     event FeePaid (address which);
32     event ManagerSet(address newManager);
33     event FactorySet(address newFactory);
34     event DepositMade(address where, uint amount);
35     event SeriesCreated(address addr, uint id);
36     
37     /// @dev This is the initialization function, here we just mark
38     /// ourselves as the General Manager for this series organization.
39     function EtherprisesLLC() {
40         generalManager = msg.sender;
41     }
42     
43     /// @dev This modifier is used to check if the user is the GM.
44     modifier ifGeneralManager {
45         if (msg.sender != generalManager)
46             throw;
47 
48         _;
49     }
50     
51     /// @dev This modifier is used to check is the caller a series.
52     modifier ifSeries {
53         if (expiresAt[msg.sender] == 0)
54             throw;
55 
56         _;
57     }
58     
59     /// @dev Withdrawal happens here from Etherprises LLC to the GM.
60     /// For bookkeeping and tax reasons we only want GM to withdraw.
61     function withdraw() ifGeneralManager {
62         generalManager.send(this.balance);
63     }
64     
65     /// @dev This checks if the series is expired. This is meant to be
66     /// called inside the series, and terminate the series if expired.
67     /// @param addr Address of the series we want to check
68     /// @return TRUE if series is expired, FALSE otherwise
69     function isExpired(address addr) constant returns (bool) {
70         if (expiresAt[addr] > now)
71             return false;
72         else
73             return true;
74     }
75     
76     /// @dev Amending rules of the organization, only those rules which
77     /// were present upon creation of the Series, apply to the Series.
78     /// @param newAmendment String containing new amendment. Remember to
79     /// prefix it with the date
80     function addAmendment(string newAmendment) ifGeneralManager {
81         // Only GM can amend the rules.
82         // Series obey only the rules which are set when series is created
83         prose.push(newAmendment);
84         
85         AmendmentAdded(newAmendment);
86     }
87     
88     /// @dev This function pays the yearly fee of 1 ETH.
89     /// @return Boolean TRUE, if everything was successful
90     function payFee() ifSeries payable returns (bool) {
91         // Receiving fee of one ETH here
92         if (msg.value != 1 ether)
93             throw;
94             
95         expiresAt[msg.sender] += 1 years;
96         
97         FeePaid(msg.sender);
98         return true;
99     }
100     
101     /// @dev Sets the general manager for the main organization.
102     /// There is just one member for Etherprises LLC, which is the GM.
103     /// @param newManger Address of the new manager
104     function setManager(address newManger) ifGeneralManager {
105         generalManager = newManger;
106         
107         ManagerSet(newManger);
108     }
109     
110     /// @dev This sets the factory proxy contract, which uses the factory.
111     /// @param newFactory Address of the new factory proxy
112     function setFactory(address newFactory) ifGeneralManager {
113         seriesFactory = newFactory;
114         
115         FactorySet(newFactory);
116     }
117     
118     /// @dev This creates a new series, called also from the fallback
119     /// with default values.
120     /// @notice This will create new series. Specify the name here: 
121     /// This is the only place to define a name, the name is immutable.
122     /// Please note, that the name must start with an alpha character
123     /// (despite otherwise being UTF-8).
124     /// Throws an exception if the name does not technically pass the tests.
125     /// @param name Name of the series, must start with A-Z, and for the
126     /// hash table the search key will exclude all other characters
127     /// except A-Z. Full Unicode is supported, though
128     /// @param shares Amount of shares, by default this is immutable
129     /// @param industry Setting industry may have legal implications,
130     /// i.e taxation
131     /// @param symbol Symbol of the traded token
132     /// @return seriesAddress Address of the newly created series contract
133     /// @return seriesId Internal incremental ID number for the series
134     function createSeries(
135         bytes name,
136         uint shares,
137         string industry,
138         string symbol,
139         address extraContract
140     ) payable returns (
141         address seriesAddress,
142         uint seriesId
143     ) {
144         seriesId = series.length;
145         
146         var(latestAddress, latestName) = SeriesFactory(seriesFactory).createSeries.value(msg.value)(seriesId, name, shares, industry, symbol, msg.sender, extraContract);
147         if (latestAddress == 0)
148             throw;
149 
150         if (latestName > 0)
151             if (seriesByName[latestName] == 0)
152                 seriesByName[latestName] = latestAddress;
153             else
154                 throw;
155 
156         series.push(latestAddress);
157         expiresAt[latestAddress] = now + 1 years;
158         latestSeriesForUser[msg.sender] = latestAddress;
159         seriesByAddress[latestAddress] = latestName;
160         
161         SeriesCreated(latestAddress, seriesId);
162         return (latestAddress, seriesId);
163     }
164     
165     /// @dev This is here for Registrar ABI support.
166     /// @param _name Name of the series we want to search, please note
167     /// this is only the search key and not full name
168     /// @return Address of the series we want to get
169     function addr(bytes32 _name) constant returns(address o_address) {
170         return seriesByName[_name];
171     }
172     
173     /// @dev This is here for Registrar ABI support: return the search key
174     /// for a contract.
175     /// @param _owner Name of the series we want to search, please note
176     /// this is only the search key and not full name
177     /// @return Name of the series we want to get
178     function name(address _owner) constant returns(bytes32 o_name){
179         return seriesByAddress[_owner];
180     }
181     
182     /// @dev Here the fallback function either creates a new series,
183     /// or transfers funds to existing one.
184     function () payable {
185         if (msg.data.length > 0) {
186             createSeries(msg.data, 0, "", "", 0x0);
187         } else if (latestSeriesForUser[msg.sender] != 0) {
188             //This is important to implement as call so we can forward gas
189             if (latestSeriesForUser[msg.sender].call.value(msg.value)())
190                 DepositMade(latestSeriesForUser[msg.sender], msg.value);
191         } else {
192             createSeries("", 0, "", "", 0x0);
193         }
194     }
195 }
196 
197 //This is a placeholder contract: In real life the main contract invokes
198 //a proxy, which in turn invokes the actual SeriesFactory
199 //The main contract for Etherprises LLC is above this one.
200 contract SeriesFactory {
201     address public seriesFactory;
202     address public owner;
203 
204     function createSeries (
205         uint seriesId,
206         bytes name,
207         uint shares,
208         string industry,
209         string symbol,
210         address manager,
211         address extraContract
212     ) payable returns (
213         address addr,
214         bytes32 newName
215     ) {
216         address newSeries;
217         bytes32 _newName;
218 
219         return (newSeries, _newName);
220     }
221 }