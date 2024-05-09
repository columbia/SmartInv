1 /***********************************************************
2 * This file is part of the Slock.it IoT Layer.             *
3 * The Slock.it IoT Layer contains:                         *
4 *   - USN (Universal Sharing Network)                      *
5 *   - INCUBED (Trustless INcentivized remote Node Network) *
6 ************************************************************
7 * Copyright (C) 2016 - 2018 Slock.it GmbH                  *
8 * All Rights Reserved.                                     *
9 ************************************************************
10 * You may use, distribute and modify this code under the   *
11 * terms of the license contract you have concluded with    *
12 * Slock.it GmbH.                                           *
13 * For information about liability, maintenance etc. also   *
14 * refer to the contract concluded with Slock.it GmbH.      *
15 ************************************************************
16 * For more information, please refer to https://slock.it    *
17 * For questions, please contact info@slock.it              *
18 ***********************************************************/
19 
20 pragma solidity ^0.4.25;
21 
22 /// @title Registry for IN3-Servers
23 contract ServerRegistry {
24 
25     /// server has been registered or updated its registry props or deposit
26     event LogServerRegistered(string url, uint props, address owner, uint deposit);
27 
28     ///  a caller requested to unregister a server.
29     event LogServerUnregisterRequested(string url, address owner, address caller);
30 
31     /// the owner canceled the unregister-proccess
32     event LogServerUnregisterCanceled(string url, address owner);
33 
34     /// a Server was convicted
35     event LogServerConvicted(string url, address owner);
36 
37     /// a Server is removed
38     event LogServerRemoved(string url, address owner);
39 
40     struct In3Server {
41         string url;  // the url of the server
42         address owner; // the owner, which is also the key to sign blockhashes
43         uint deposit; // stored deposit
44         uint props; // a list of properties-flags representing the capabilities of the server
45 
46         // unregister state
47         uint128 unregisterTime; // earliest timestamp in to to call unregister
48         uint128 unregisterDeposit; // Deposit for unregistering
49         address unregisterCaller; // address of the caller requesting the unregister
50     }
51 
52     /// server list of incubed nodes    
53     In3Server[] public servers;
54 
55     // index for unique url and owner
56     mapping (address => bool) ownerIndex;
57     mapping (bytes32 => bool) urlIndex;
58     
59     /// length of the serverlist
60     function totalServers() public view returns (uint)  {
61         return servers.length;
62     }
63 
64     /// register a new Server with the sender as owner    
65     function registerServer(string _url, uint _props) public payable {
66         checkLimits();
67 
68         bytes32 urlHash = keccak256(bytes(_url));
69 
70         // make sure this url and also this owner was not registered before.
71         require (!urlIndex[urlHash] && !ownerIndex[msg.sender], "a Server with the same url or owner is already registered");
72 
73         // add new In3Server
74         In3Server memory m;
75         m.url = _url;
76         m.props = _props;
77         m.owner = msg.sender;
78         m.deposit = msg.value;
79         servers.push(m);
80 
81         // make sure they are used
82         urlIndex[urlHash] = true;
83         ownerIndex[msg.sender] = true;
84 
85         // emit event
86         emit LogServerRegistered(_url, _props, msg.sender,msg.value);
87     }
88 
89     /// updates a Server by adding the msg.value to the deposit and setting the props    
90     function updateServer(uint _serverIndex, uint _props) public payable {
91         checkLimits();
92 
93         In3Server storage server = servers[_serverIndex];
94         require(server.owner == msg.sender, "only the owner may update the server");
95 
96         if (msg.value>0) 
97           server.deposit += msg.value;
98 
99         if (_props!=server.props)
100           server.props = _props;
101         emit LogServerRegistered(server.url, _props, msg.sender,server.deposit);
102     }
103 
104     /// this should be called before unregistering a server.
105     /// there are 2 use cases:
106     /// a) the owner wants to stop offering the service and remove the server.
107     ///    in this case he has to wait for one hour before actually removing the server. 
108     ///    This is needed in order to give others a chance to convict it in case this server signs wrong hashes
109     /// b) anybody can request to remove a server because it has been inactive.
110     ///    in this case he needs to pay a small deposit, which he will lose 
111     //       if the owner become active again 
112     //       or the caller will receive 20% of the deposit in case the owner does not react.
113     function requestUnregisteringServer(uint _serverIndex) payable public {
114 
115         In3Server storage server = servers[_serverIndex];
116 
117         // this can only be called if nobody requested it before
118         require(server.unregisterCaller == address(0x0), "Server is already unregistering");
119 
120         if (server.unregisterCaller == server.owner) 
121            server.unregisterTime = uint128(now + 1 hours);
122         else {
123             server.unregisterTime = uint128(now + 28 days); // 28 days are always good ;-) 
124             // the requester needs to pay the unregisterDeposit in order to spam-protect the server
125             require(msg.value == calcUnregisterDeposit(_serverIndex), "the exact calcUnregisterDeposit is required to request unregister");
126             server.unregisterDeposit = uint128(msg.value);
127         }
128         server.unregisterCaller = msg.sender;
129         emit LogServerUnregisterRequested(server.url, server.owner, msg.sender);
130     }
131     
132     /// this function must be called by the caller of the requestUnregisteringServer-function after 28 days
133     /// if the owner did not cancel, the caller will receive 20% of the server deposit + his own deposit.
134     /// the owner will receive 80% of the server deposit before the server will be removed.
135     function confirmUnregisteringServer(uint _serverIndex) public {
136         In3Server storage server = servers[_serverIndex];
137         // this can only be called if somebody requested it before
138         require(server.unregisterCaller != address(0x0) && server.unregisterTime < now, "Only the caller is allowed to confirm");
139 
140         uint payBackOwner = server.deposit;
141         if (server.unregisterCaller != server.owner) {
142             payBackOwner -= server.deposit / 5;  // the owner will only receive 80% of his deposit back.
143             server.unregisterCaller.transfer(server.unregisterDeposit + server.deposit - payBackOwner);
144         }
145 
146         if (payBackOwner > 0)
147             server.owner.transfer(payBackOwner);
148 
149         removeServer(_serverIndex);
150     }
151 
152     /// this function must be called by the owner to cancel the unregister-process.
153     /// if the caller is not the owner, then he will also get the deposit paid by the caller.
154     function cancelUnregisteringServer(uint _serverIndex) public {
155         In3Server storage server = servers[_serverIndex];
156 
157         // this can only be called by the owner and if somebody requested it before
158         require(server.unregisterCaller != address(0) && server.owner == msg.sender, "only the owner is allowed to cancel unregister");
159 
160         // if this was requested by somebody who does not own this server,
161         // the owner will get his deposit
162         if (server.unregisterCaller != server.owner) 
163             server.owner.transfer(server.unregisterDeposit);
164 
165         // set back storage values
166         server.unregisterCaller = address(0);
167         server.unregisterTime = 0;
168         server.unregisterDeposit = 0;
169 
170         /// emit event
171         emit LogServerUnregisterCanceled(server.url, server.owner);
172     }
173 
174 
175     /// convicts a server that signed a wrong blockhash
176     function convict(uint _serverIndex, bytes32 _blockhash, uint _blocknumber, uint8 _v, bytes32 _r, bytes32 _s) public {
177         bytes32 evm_blockhash = blockhash(_blocknumber);
178         
179         // if the blockhash is correct you cannot convict the server
180         require(evm_blockhash != 0x0 && evm_blockhash != _blockhash, "the block is too old or you try to convict with a correct hash");
181 
182         // make sure the hash was signed by the owner of the server
183         require(
184             ecrecover(keccak256(_blockhash, _blocknumber), _v, _r, _s) == servers[_serverIndex].owner, 
185             "the block was not signed by the owner of the server");
186 
187         // remove the deposit
188         if (servers[_serverIndex].deposit > 0) {
189             uint payout = servers[_serverIndex].deposit / 2;
190             // send 50% to the caller of this function
191             msg.sender.transfer(payout);
192 
193             // and burn the rest by sending it to the 0x0-address
194             // this is done in order to make it useless trying to convict your own server with a second account
195             // and this getting all the deposit back after signing a wrong hash.
196             address(0).transfer(servers[_serverIndex].deposit-payout);
197         }
198 
199         // emit event
200         emit LogServerConvicted(servers[_serverIndex].url, servers[_serverIndex].owner );
201         
202         removeServer(_serverIndex);
203     }
204 
205     /// calculates the minimum deposit you need to pay in order to request unregistering of a server.
206     function calcUnregisterDeposit(uint _serverIndex) public view returns(uint128) {
207          // cancelUnregisteringServer costs 22k gas, we took about twist that much due to volatility of gasPrices
208         return uint128(servers[_serverIndex].deposit / 50 + tx.gasprice * 50000);
209     }
210 
211     // internal helper functions
212     
213     function removeServer(uint _serverIndex) internal {
214         // trigger event
215         emit LogServerRemoved(servers[_serverIndex].url, servers[_serverIndex].owner);
216 
217         // remove from unique index
218         urlIndex[keccak256(bytes(servers[_serverIndex].url))] = false;
219         ownerIndex[servers[_serverIndex].owner] = false;
220 
221         uint length = servers.length;
222         if (length>0) {
223             // move the last entry to the removed one.
224             In3Server memory m = servers[length - 1];
225             servers[_serverIndex] = m;
226         }
227         servers.length--;
228     }
229 
230     function checkLimits() internal view {
231         // within the next 6 months this contract may never hold more than 50 ETH
232         if (now < 1560808800)
233            require(address(this).balance < 50 ether, "Limit of 50 ETH reached");
234     }
235 
236 }