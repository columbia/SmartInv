1 contract ClassicCheck {
2        function isClassic() constant returns (bool isClassic);
3 }
4 
5 contract SafeConditionalHFTransfer {
6 
7     bool classic;
8     
9     function SafeConditionalHFTransfer() {
10         classic = ClassicCheck(0x882fb4240f9a11e197923d0507de9a983ed69239).isClassic();
11     }
12     
13     function classicTransfer(address to) {
14         if (!classic) 
15             msg.sender.send(msg.value);
16         else
17             to.send(msg.value);
18     }
19     
20     function transfer(address to) {
21         if (classic)
22             msg.sender.send(msg.value);
23         else
24             to.send(msg.value);
25     }
26     
27 }