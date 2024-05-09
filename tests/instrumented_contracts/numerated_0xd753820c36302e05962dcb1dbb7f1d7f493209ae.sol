1 contract Rental {
2     enum ItemState {
3         Idle, Busy
4     }
5     
6     struct Item {
7         address owner;
8         string name;
9         string serialNumber;
10         ItemState state;
11     }
12     
13     enum RequestState {
14         Pending, Canceled, Accepted, Finished
15     }
16     
17     struct Request {
18         address client;
19         uint itemId;
20         uint fee;
21         string start;
22         string end;
23         RequestState state;
24     }
25     
26     Item[] public items;
27     Request[] public requests;
28     
29     function getItemsLength() public constant returns (uint) {
30         return items.length;
31     }
32     
33     function getRequestsLength() public constant returns (uint) {
34         return requests.length;
35     }
36     
37     function addItem(string _name, string _serialNumber) public returns (uint) {
38         Item memory newItem = Item({
39           owner: msg.sender,
40           name: _name,
41           serialNumber: _serialNumber,
42           state: ItemState.Idle
43         });
44         return items.push(newItem) - 1;
45     }
46     
47     function addRequest(uint _itemId, string _start, string _end) public payable returns (uint) {
48         Request memory newRequest = Request({
49            client: msg.sender,
50            itemId: _itemId,
51            fee: msg.value,
52            start: _start,
53            end: _end,
54            state: RequestState.Pending
55         });
56         return requests.push(newRequest) - 1;
57     }
58     
59     function cancelRequest(uint _requestId) public {
60         Request storage req = requests[_requestId];
61         require(req.client == msg.sender);
62         require(req.state == RequestState.Pending);
63         req.state = RequestState.Canceled;
64         msg.sender.transfer(req.fee);
65     }
66     
67     function acceptRequest(uint _requestId) public {
68         Request storage req = requests[_requestId];
69         require(req.state == RequestState.Pending);
70         Item storage item = items[req.itemId];
71         require(item.owner == msg.sender);
72         require(item.state == ItemState.Idle);
73         item.state = ItemState.Busy;
74         req.state = RequestState.Accepted;
75         msg.sender.transfer(req.fee);
76     }
77     
78     function acceptReturning(uint _requestId) public {
79         Request storage req = requests[_requestId];
80         require(req.state == RequestState.Accepted);
81         Item storage item = items[req.itemId];
82         require(item.owner == msg.sender);
83         require(item.state == ItemState.Busy);
84         item.state = ItemState.Idle;
85         req.state = RequestState.Finished;
86     }
87 }