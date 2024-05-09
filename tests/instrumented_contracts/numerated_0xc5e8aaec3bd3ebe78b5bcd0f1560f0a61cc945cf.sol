1 contract InsuranceAgent {
2     address public owner;
3     event CoinTransfer(address sender, address receiver, uint amount);
4 
5     struct Client {
6         address addr;
7     }
8 
9     struct Payment {
10         uint amount;
11         uint date; // timestamp
12     }
13 
14     struct Payout {
15         bytes32 proof;
16         uint amount;
17         uint date; // timestamp
18         uint veto; // clientId
19     }
20 
21     mapping (uint => Payout) public payouts; // clientId -> requested payout
22     mapping (uint => Payment[]) public payments; // clientId -> list of his Payments
23     mapping (uint => Client) public clients; // clientId -> info about Client
24 
25     modifier costs(uint _amount) {
26         if (msg.value < _amount)
27             throw;
28         _
29     }
30 
31     modifier onlyBy(address _account) {
32         if (msg.sender != _account)
33             throw;
34         _
35     }
36 
37     function InsuranceAgent() {
38         owner = msg.sender;
39     }
40 
41     function newClient(uint clientId, address clientAddr) onlyBy(owner) {
42         clients[clientId] = Client({
43             addr: clientAddr
44         });
45     }
46 
47     function newPayment(uint clientId, uint timestamp) costs(5000000000000000) {
48         payments[clientId].push(Payment({
49             amount: msg.value,
50             date: timestamp
51         }));
52     }
53 
54     function requestPayout(uint clientId, uint amount, bytes32 proof, uint date, uint veto) onlyBy(owner) {
55         // only one payout at the same time for the same client available
56         // amount should be in wei
57         payouts[clientId] = Payout({
58             proof: proof,
59             amount: amount,
60             date: date,
61             veto: veto
62         });
63     }
64 
65     function vetoPayout(uint clientId, uint proverId) onlyBy(owner) {
66         payouts[clientId].veto = proverId;
67     }
68 
69     function payRequstedSum(uint clientId, uint date) onlyBy(owner) {
70         if (payouts[clientId].veto != 0) { throw; }
71         if (date - payouts[clientId].date < 60 * 60 * 24 * 3) { throw; }
72         clients[clientId].addr.send(payouts[clientId].amount);
73         delete payouts[clientId];
74     }
75 
76     function getStatusOfPayout(uint clientId) constant returns (uint, uint, uint, bytes32) {
77         return (payouts[clientId].amount, payouts[clientId].date,
78                 payouts[clientId].veto, payouts[clientId].proof);
79     }
80 
81     function getNumberOfPayments(uint clientId) constant returns (uint) {
82         return payments[clientId].length;
83     }
84 
85     function getPayment(uint clientId, uint paymentId) constant returns (uint, uint) {
86         return (payments[clientId][paymentId].amount, payments[clientId][paymentId].date);
87     }
88 
89     function getClient(uint clientId) constant returns (address) {
90         return clients[clientId].addr;
91     }
92 
93     function () {
94         // This function gets executed if a
95         // transaction with invalid data is sent to
96         // the contract or just ether without data.
97         // We revert the send so that no-one
98         // accidentally loses money when using the
99         // contract.
100         throw;
101     }
102 
103 }