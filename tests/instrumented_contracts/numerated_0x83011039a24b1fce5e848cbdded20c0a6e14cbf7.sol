1 pragma solidity ^0.4.22;
2 
3 contract AddressProxy {
4 
5     /**
6     * @dev The owner owns the address proxy and has the highest access
7     */
8     address public owner;
9 
10     /**
11     * @dev The client is the address that has day to day access
12     */
13     address public client;
14 
15     /**
16     * @dev If the proxy is locked, the client can't access the proxy anymore
17     */
18     bool public locked;
19 
20     /**
21     * @param _owner the address that "own" the proxy and interact with it most of the time
22     * @param _client this is the "master" address and can swap the client address
23     */
24     constructor(address _owner, address _client) public {
25         owner = _owner;
26         client = _client;
27         locked = false;
28     }
29 
30     modifier auth() {
31         require(msg.sender == owner || msg.sender == client);
32         _;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     modifier isUnlocked() {
41         require(locked == false);
42         _;
43     }
44 
45     event ChangedOwner(address _newOwner);
46     event ChangedClient(address _newClient);
47 
48     //make contract payable
49     function() payable public {}
50 
51     /**
52     * @param _location is the target contract address
53     * @param _data is "what" you want to execute on the target contract
54     * @param _ether the amount of ether to send with the execution (IN WEI)
55     */
56     function exec(address _location, bytes _data, uint256 _ether) payable external auth() isUnlocked() {
57         require(_location.call.value(_ether)(_data));
58     }
59 
60     /**
61     * @param _to the address to where you want to send ether
62     * @param _amount the amount of ether you want to send IN WEI
63     */
64     function sendEther(address _to, uint _amount) external auth() isUnlocked() {
65         _to.transfer(_amount);
66     }
67 
68     /**
69     * @param _location is the target contract address
70     * @param _data is "what" you want to execute on the target contract
71     * @param _value how much ether should be transferred (in wei)
72     * @param _gas the amount of gas in wei
73     */
74     function execCustom(address _location, bytes _data, uint256 _value, uint256 _gas) payable external auth() isUnlocked() {
75         require(_location.call.value(_value).gas(_gas)(_data));
76     }
77 
78     /**
79     * @dev lock's down the proxy and prevent the call of "exec" by ownerAddress and recoveryAddress
80     */
81     function lock() external auth() {
82         locked = true;
83     }
84 
85     /**
86     * @dev unlock's the proxy. Can only be done by recovery address
87     */
88     function unlock() external onlyOwner() {
89         locked = false;
90     }
91 
92     /**
93     * @dev set new owner of proxy contract and remove the old one
94     * @param _newOwner the new owner
95     */
96     function changeOwner(address _newOwner) external onlyOwner() {
97         owner = _newOwner;
98         emit ChangedOwner(owner);
99     }
100 
101     /**
102     * @dev Change the client address
103     * @param _newClient the new client
104     */
105     function changeClient(address _newClient) external onlyOwner() {
106         client = _newClient;
107         emit ChangedClient(client);
108     }
109 
110 }