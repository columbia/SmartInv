1 contract BlockmaticsGraduationCertificate_102417 {
2     address public owner = msg.sender;
3     string certificate;
4     bool certIssued = false;
5 
6     function publishGraduatingClass(string cert) {
7         if (msg.sender != owner || certIssued)
8             throw;
9         certIssued = true;
10         certificate = cert;
11     }
12 
13     function showBlockmaticsCertificate() constant returns (string) {
14         return certificate;
15     }
16 }