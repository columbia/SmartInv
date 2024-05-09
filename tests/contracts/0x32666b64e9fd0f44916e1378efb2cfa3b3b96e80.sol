/**

Deployed by Ren Project, https://renproject.io

Commit hash: 9068f80
Repository: https://github.com/renproject/darknode-sol
Issues: https://github.com/renproject/darknode-sol/issues

Licenses
@openzeppelin/contracts: (MIT) https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/LICENSE
darknode-sol: (GNU GPL V3) https://github.com/renproject/darknode-sol/blob/master/LICENSE

*/

pragma solidity 0.5.16;


contract Initializable {

  
  bool private initialized;

  
  bool private initializing;

  
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  
  function isConstructor() private view returns (bool) {
    
    
    
    
    
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
}

contract IRelayRecipient {
    
    function getHubAddr() public view returns (address);

    
    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    )
        external
        view
        returns (uint256, bytes memory);

    
    function preRelayedCall(bytes calldata context) external returns (bytes32);

    
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
}

contract IRelayHub {
    

    
    function stake(address relayaddr, uint256 unstakeDelay) external payable;

    
    event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);

    
    function registerRelay(uint256 transactionFee, string memory url) public;

    
    event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);

    
    function removeRelayByOwner(address relay) public;

    
    event RelayRemoved(address indexed relay, uint256 unstakeTime);

    
    function unstake(address relay) public;

    
    event Unstaked(address indexed relay, uint256 stake);

    
    enum RelayState {
        Unknown, 
        Staked, 
        Registered, 
        Removed    
    }

    
    function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);

    

    
    function depositFor(address target) public payable;

    
    event Deposited(address indexed recipient, address indexed from, uint256 amount);

    
    function balanceOf(address target) external view returns (uint256);

    
    function withdraw(uint256 amount, address payable dest) public;

    
    event Withdrawn(address indexed account, address indexed dest, uint256 amount);

    

    
    function canRelay(
        address relay,
        address from,
        address to,
        bytes memory encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes memory signature,
        bytes memory approvalData
    ) public view returns (uint256 status, bytes memory recipientContext);

    
    enum PreconditionCheck {
        OK,                         
        WrongSignature,             
        WrongNonce,                 
        AcceptRelayedCallReverted,  
        InvalidRecipientStatusCode  
    }

    
    function relayCall(
        address from,
        address to,
        bytes memory encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes memory signature,
        bytes memory approvalData
    ) public;

    
    event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);

    
    event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);

    
    enum RelayCallStatus {
        OK,                      
        RelayedCallFailed,       
        PreRelayedFailed,        
        PostRelayedFailed,       
        RecipientBalanceChanged  
    }

    
    function requiredGas(uint256 relayedCallStipend) public view returns (uint256);

    
    function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);

     
     
    
    

    
    function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;

    
    function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;

    
    event Penalized(address indexed relay, address sender, uint256 amount);

    
    function getNonce(address from) external view returns (uint256);
}

contract Context is Initializable {
    
    
    constructor () internal { }
    

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; 
        return msg.data;
    }
}

contract GSNRecipient is Initializable, IRelayRecipient, Context {
    function initialize() public initializer {
        if (_relayHub == address(0)) {
            setDefaultRelayHub();
        }
    }

    function setDefaultRelayHub() public {
        _upgradeRelayHub(0xD216153c06E857cD7f72665E0aF1d7D82172F494);
    }

    
    address private _relayHub;

    uint256 constant private RELAYED_CALL_ACCEPTED = 0;
    uint256 constant private RELAYED_CALL_REJECTED = 11;

    
    uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;

    
    event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);

    
    function getHubAddr() public view returns (address) {
        return _relayHub;
    }

    
    function _upgradeRelayHub(address newRelayHub) internal {
        address currentRelayHub = _relayHub;
        require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
        require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");

        emit RelayHubChanged(currentRelayHub, newRelayHub);

        _relayHub = newRelayHub;
    }

    
    
    
    function relayHubVersion() public view returns (string memory) {
        this; 
        return "1.0.0";
    }

    
    function _withdrawDeposits(uint256 amount, address payable payee) internal {
        IRelayHub(_relayHub).withdraw(amount, payee);
    }

    
    
    
    

    
    function _msgSender() internal view returns (address payable) {
        if (msg.sender != _relayHub) {
            return msg.sender;
        } else {
            return _getRelayedCallSender();
        }
    }

    
    function _msgData() internal view returns (bytes memory) {
        if (msg.sender != _relayHub) {
            return msg.data;
        } else {
            return _getRelayedCallData();
        }
    }

    
    

    
    function preRelayedCall(bytes calldata context) external returns (bytes32) {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        return _preRelayedCall(context);
    }

    
    function _preRelayedCall(bytes memory context) internal returns (bytes32);

    
    function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
        require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
        _postRelayedCall(context, success, actualCharge, preRetVal);
    }

    
    function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;

    
    function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
        return _approveRelayedCall("");
    }

    
    function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_ACCEPTED, context);
    }

    
    function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
        return (RELAYED_CALL_REJECTED + errorCode, "");
    }

    
    function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
        
        
        return (gas * gasPrice * (100 + serviceFee)) / 100;
    }

    function _getRelayedCallSender() private pure returns (address payable result) {
        
        
        
        
        

        
        

        
        bytes memory array = msg.data;
        uint256 index = msg.data.length;

        
        assembly {
            
            result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    function _getRelayedCallData() private pure returns (bytes memory) {
        
        

        uint256 actualDataLength = msg.data.length - 20;
        bytes memory actualData = new bytes(actualDataLength);

        for (uint256 i = 0; i < actualDataLength; ++i) {
            actualData[i] = msg.data[i];
        }

        return actualData;
    }
}

interface IMintGateway {
    function mint(
        bytes32 _pHash,
        uint256 _amount,
        bytes32 _nHash,
        bytes calldata _sig
    ) external returns (uint256);
    function mintFee() external view returns (uint256);
}

interface IBurnGateway {
    function burn(bytes calldata _to, uint256 _amountScaled)
        external
        returns (uint256);
    function burnFee() external view returns (uint256);
}

interface IGateway {
    
    function mint(
        bytes32 _pHash,
        uint256 _amount,
        bytes32 _nHash,
        bytes calldata _sig
    ) external returns (uint256);
    function mintFee() external view returns (uint256);
    
    function burn(bytes calldata _to, uint256 _amountScaled)
        external
        returns (uint256);
    function burnFee() external view returns (uint256);
}

interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address recipient, uint256 amount) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

    
    function approve(address spender, uint256 amount) external returns (bool);

    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IGatewayRegistry {
    
    
    event LogGatewayRegistered(
        string _symbol,
        string indexed _indexedSymbol,
        address indexed _tokenAddress,
        address indexed _gatewayAddress
    );
    event LogGatewayDeregistered(
        string _symbol,
        string indexed _indexedSymbol,
        address indexed _tokenAddress,
        address indexed _gatewayAddress
    );
    event LogGatewayUpdated(
        address indexed _tokenAddress,
        address indexed _currentGatewayAddress,
        address indexed _newGatewayAddress
    );

    
    function getGateways(address _start, uint256 _count)
        external
        view
        returns (address[] memory);

    
    function getRenTokens(address _start, uint256 _count)
        external
        view
        returns (address[] memory);

    
    
    
    
    function getGatewayByToken(address _tokenAddress)
        external
        view
        returns (IGateway);

    
    
    
    
    function getGatewayBySymbol(string calldata _tokenSymbol)
        external
        view
        returns (IGateway);

    
    
    
    
    function getTokenBySymbol(string calldata _tokenSymbol)
        external
        view
        returns (IERC20);
}

contract BasicAdapter is GSNRecipient {
    IGatewayRegistry registry;

    constructor(IGatewayRegistry _registry) public {
        GSNRecipient.initialize();
        registry = _registry;
    }

    function mint(
        
        string calldata _symbol,
        address _recipient,
        
        uint256 _amount,
        bytes32 _nHash,
        bytes calldata _sig
    ) external {
        bytes32 payloadHash = keccak256(abi.encode(_symbol, _recipient));
        uint256 amount = registry.getGatewayBySymbol(_symbol).mint(
            payloadHash,
            _amount,
            _nHash,
            _sig
        );
        registry.getTokenBySymbol(_symbol).transfer(_recipient, amount);
    }

    function burn(string calldata _symbol, bytes calldata _to, uint256 _amount)
        external
    {
        require(
            registry.getTokenBySymbol(_symbol).transferFrom(
                _msgSender(),
                address(this),
                _amount
            ),
            "token transfer failed"
        );
        registry.getGatewayBySymbol(_symbol).burn(_to, _amount);
    }

    

    function acceptRelayedCall(
        address relay,
        address from,
        bytes calldata encodedFunction,
        uint256 transactionFee,
        uint256 gasPrice,
        uint256 gasLimit,
        uint256 nonce,
        bytes calldata approvalData,
        uint256 maxPossibleCharge
    ) external view returns (uint256, bytes memory) {
        return _approveRelayedCall();
    }

    
    function _preRelayedCall(bytes memory context) internal returns (bytes32) {}

    function _postRelayedCall(
        bytes memory context,
        bool,
        uint256 actualCharge,
        bytes32
    ) internal {}
}