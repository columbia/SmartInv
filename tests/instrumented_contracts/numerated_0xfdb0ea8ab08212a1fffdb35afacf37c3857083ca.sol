1 pragma solidity ^0.4.19;
2 
3 /// @title Registry for IN3-Nodes
4 contract ServerRegistry {
5 
6     uint internal constant unregisterDeposit = 100000;
7 
8     event LogServerRegistered(string url, uint props, address owner, uint deposit);
9     event LogServerUnregisterRequested(string url, address owner, address caller);
10     event LogServerUnregisterCanceled(string url, address owner);
11     event LogServerConvicted(string url, address owner);
12     event LogServerRemoved(string url, address owner);
13 
14     struct Web3Server {
15         string url;  // the url of the server
16         address owner; // the owner, which is also the key to sign blockhashes
17         uint deposit; // stored deposit
18         uint props; // a list of properties-flags representing the capabilities of the server
19 
20         // unregister state
21         uint unregisterTime; // earliest timestamp in to to call unregister
22         address unregisterCaller; // address of the caller requesting the unregister
23     }
24     
25     Web3Server[] public servers;
26 
27     function totalServers() public constant returns (uint)  {
28         return servers.length;
29     }
30 
31     /// register a new Server with the sender as owner    
32     function registerServer(string _url, uint _props) public payable {
33         // make sure this url and also this owner was not registered before.
34         bytes32 hash = keccak256(_url);
35         for (uint i=0;i<servers.length;i++) 
36             require(keccak256(servers[i].url)!=hash && servers[i].owner!=msg.sender);
37 
38         // create new Webserver
39         Web3Server memory m;
40         m.url = _url;
41         m.props = _props;
42         m.owner = msg.sender;
43         m.deposit = msg.value;
44         servers.push(m);
45         emit LogServerRegistered(_url, _props, msg.sender,msg.value);
46     }
47 
48     /// this should be called before unregistering a server.
49     /// there are 2 use cases:
50     /// a) the owner wants to stop offering this.
51     ///    in this case he has to wait for one hour before actually removing the server.
52     ///    This is needed in order to give others a chance to convict it in case this server signs wrong hashes
53     /// b) anybody can request to remove a server because it has been inactive.
54     ///    in this case he needs to pay a small deposit, which he will lose 
55     //       if the owner become active again 
56     //       or the caller will receive 20% of the deposit in case the owner does not react.
57     function requestUnregisteringServer(uint _serverIndex) payable public {
58         Web3Server storage server = servers[_serverIndex];
59         // this can only be called if nobody requested it before
60         require(server.unregisterCaller==address(0x0));
61 
62         if (server.unregisterCaller == server.owner) 
63            server.unregisterTime = now + 1 hours;
64         else {
65             server.unregisterTime = now + 28 days; // 28 days are always good ;-) 
66             // the requester needs to pay the unregisterDeposit in order to spam-protect the server
67             require(msg.value==unregisterDeposit);
68         }
69         server.unregisterCaller = msg.sender;
70         emit LogServerUnregisterRequested(server.url, server.owner, msg.sender );
71     }
72     
73     function confirmUnregisteringServer(uint _serverIndex) public {
74         Web3Server storage server = servers[_serverIndex];
75         // this can only be called if somebody requested it before
76         require(server.unregisterCaller!=address(0x0) && server.unregisterTime < now);
77 
78         uint payBackOwner = server.deposit;
79         if (server.unregisterCaller != server.owner) {
80             payBackOwner -= server.deposit/5;  // the owner will only receive 80% of his deposit back.
81             server.unregisterCaller.transfer( unregisterDeposit + server.deposit - payBackOwner );
82         }
83 
84         if (payBackOwner>0)
85             server.owner.transfer( payBackOwner );
86 
87         removeServer(_serverIndex);
88     }
89 
90     function cancelUnregisteringServer(uint _serverIndex) public {
91         Web3Server storage server = servers[_serverIndex];
92 
93         // this can only be called by the owner and if somebody requested it before
94         require(server.unregisterCaller!=address(0) &&  server.owner == msg.sender);
95 
96         // if this was requested by somebody who does not own this server,
97         // the owner will get his deposit
98         if (server.unregisterCaller != server.owner) 
99             server.owner.transfer( unregisterDeposit );
100 
101         server.unregisterCaller = address(0);
102         server.unregisterTime = 0;
103         
104         emit LogServerUnregisterCanceled(server.url, server.owner);
105     }
106 
107 
108     function convict(uint _serverIndex, bytes32 _blockhash, uint _blocknumber, uint8 _v, bytes32 _r, bytes32 _s) public {
109         // if the blockhash is correct you cannot convict the server
110         require(blockhash(_blocknumber) != _blockhash);
111 
112         // make sure the hash was signed by the owner of the server
113         require(ecrecover(keccak256(_blockhash, _blocknumber), _v, _r, _s) == servers[_serverIndex].owner);
114 
115         // remove the deposit
116         if (servers[_serverIndex].deposit>0) {
117             uint payout = servers[_serverIndex].deposit/2;
118             // send 50% to the caller of this function
119             msg.sender.transfer(payout);
120 
121             // and burn the rest by sending it to the 0x0-address
122             address(0).transfer(servers[_serverIndex].deposit-payout);
123         }
124 
125         emit LogServerConvicted(servers[_serverIndex].url, servers[_serverIndex].owner );
126         removeServer(_serverIndex);
127 
128     }
129     
130     // internal helpers
131     
132     function removeServer(uint _serverIndex) internal {
133         emit LogServerRemoved(servers[_serverIndex].url, servers[_serverIndex].owner );
134         uint length = servers.length;
135         Web3Server memory m = servers[length - 1];
136         servers[_serverIndex] = m;
137         servers.length--;
138     }
139 }