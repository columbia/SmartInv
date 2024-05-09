1 contract DataService {
2     event NewDataRequest(uint id, bool initialized, string dataUrl); 
3     event GetDataRequestLength(uint length);
4     event GetDataRequest(uint id, bool initialized, string dataurl, uint dataPointsLength);
5 
6     event AddDataPoint(uint dataRequestId, bool success, string response);
7     event GetDataPoint(uint dataRequestId, uint id, bool success, string response);
8 
9     struct DataPoint {
10         bool initialized;
11         bool success;
12         string response; 
13     }
14     struct DataRequest {
15         bool initialized;
16         string dataUrl;
17         DataPoint[] dataPoints;
18     }
19 
20     address private organizer;
21     DataRequest[] private dataRequests;
22 
23     // Create a new lottery with numOfBets supported bets.
24     function DataService() {
25         organizer = msg.sender;
26     }
27     
28     // Fallback function returns ether
29     function() {
30         throw;
31     }
32     
33     // Lets the organizer add a new data request
34     function addDataRequest(string dataUrl) {
35         // Only let organizer add requests for now
36         if(msg.sender != organizer) { throw; }
37 
38         // Figure out where to store the new DataRequest (next available element)
39         uint nextIndex = dataRequests.length++;
40     
41         // Init the data request and save it
42         DataRequest newDataRequest = dataRequests[nextIndex];
43         newDataRequest.initialized = true;
44         newDataRequest.dataUrl = dataUrl;
45 
46         NewDataRequest(dataRequests.length - 1, newDataRequest.initialized, newDataRequest.dataUrl);
47     }
48 
49     // Returns the amount of dataRequests currently present
50     function getDataRequestLength() {
51         GetDataRequestLength(dataRequests.length);
52     }
53 
54     // Logs the data request with the requested ID
55     function getDataRequest(uint id) {
56         DataRequest dataRequest = dataRequests[id];
57         GetDataRequest(id, dataRequest.initialized, dataRequest.dataUrl, dataRequest.dataPoints.length);
58     }
59 
60     // Gets the data point associated with the provided dataRequest.
61     function getDataPoint(uint dataRequestId, uint dataPointId) {
62         DataRequest dataRequest = dataRequests[dataRequestId];
63         DataPoint dataPoint = dataRequest.dataPoints[dataPointId];
64 
65         GetDataPoint(dataRequestId, dataPointId, dataPoint.success, dataPoint.response);
66     }
67 
68     // Lets the organizer add a new data point
69     function addDataPoint(uint dataRequestId, bool success, string response) {
70         if(msg.sender != organizer) { throw; }
71         
72         // Get the DataRequest to edit, only allow adding a data point if initialized
73         DataRequest dataRequest = dataRequests[dataRequestId];
74         if(!dataRequest.initialized) { throw; }
75 
76         // Init the new DataPoint and save it
77         DataPoint newDataPoint = dataRequest.dataPoints[dataRequest.dataPoints.length++];
78         newDataPoint.initialized = true;
79         newDataPoint.success = success;
80         newDataPoint.response = response;
81 
82         AddDataPoint(dataRequestId, success, response);
83     }
84 
85     // Suicide :(
86     function destroy() {
87         if(msg.sender != organizer) { throw; }
88         
89         suicide(organizer);
90     }
91 }