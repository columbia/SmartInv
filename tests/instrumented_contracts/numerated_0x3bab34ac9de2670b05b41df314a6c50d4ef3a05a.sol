1 contract BlockmaticsGraduationCertificate_092818 {
2     address public owner = msg.sender;
3     string public certificate;
4     bool public certIssued = false;
5 
6     function publishGraduatingClass (string cert) public {
7         assert (msg.sender == owner && !certIssued);
8 
9         certIssued = true;
10         certificate = cert;
11     }
12 }