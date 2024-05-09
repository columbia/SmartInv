pragma solidity 0.5.11;


interface DharmaSmartWalletInterface {
  enum ActionType {
    Cancel, SetUserSigningKey, Generic, GenericAtomicBatch, SAIWithdrawal,
    USDCWithdrawal, ETHWithdrawal, SetEscapeHatch, RemoveEscapeHatch,
    DisableEscapeHatch, DAIWithdrawal, _ELEVEN, _TWELVE, _THIRTEEN,
    _FOURTEEN, _FIFTEEN, _SIXTEEN, _SEVENTEEN, _EIGHTEEN, _NINETEEN, _TWENTY
  }
  function getVersion() external pure returns (uint256 version);
}


interface DharmaSmartWalletFactoryV1Interface {
  function newSmartWallet(
    address userSigningKey
  ) external returns (address wallet);
  
  function getNextSmartWallet(
    address userSigningKey
  ) external view returns (address wallet);
}

interface DharmaKeyRingFactoryV2Interface {
  function newKeyRing(
    address userSigningKey, address targetKeyRing
  ) external returns (address keyRing);

  function getNextKeyRing(
    address userSigningKey
  ) external view returns (address targetKeyRing);
}


interface DharmaKeyRegistryInterface {
  function getKeyForUser(address account) external view returns (address key);
}


contract DharmaDeploymentHelper {
  DharmaSmartWalletFactoryV1Interface internal constant _WALLET_FACTORY = (
    DharmaSmartWalletFactoryV1Interface(
      0xfc00C80b0000007F73004edB00094caD80626d8D
    )
  );
  
  DharmaKeyRingFactoryV2Interface internal constant _KEYRING_FACTORY = (
    DharmaKeyRingFactoryV2Interface(
      0x2484000059004afB720000dc738434fA6200F49D
    )
  );

  DharmaKeyRegistryInterface internal constant _KEY_REGISTRY = (
    DharmaKeyRegistryInterface(
      0x000000000D38df53b45C5733c7b34000dE0BDF52
    )
  );
  
  address internal constant beacon = 0x000000000026750c571ce882B17016557279ADaa;

  // Use the smart wallet instance runtime code hash to verify expected targets.
  bytes32 internal constant _SMART_WALLET_INSTANCE_RUNTIME_HASH = bytes32(
    0xe25d4f154acb2394ee6c18d64fb5635959ba063d57f83091ec9cf34be16224d7
  );

  // The keyring instance runtime code hash is used to verify expected targets.
  bytes32 internal constant _KEY_RING_INSTANCE_RUNTIME_HASH = bytes32(
    0xb15b24278e79e856d35b262e76ff7d3a759b17e625ff72adde4116805af59648
  );
  
  // Deploy a smart wallet and call it with arbitrary data.
  function deployWalletAndCall(
    address userSigningKey, // the key ring
    address smartWallet,
    bytes calldata data
  ) external returns (bool ok, bytes memory returnData) {
    _deployNewSmartWalletIfNeeded(userSigningKey, smartWallet);
    (ok, returnData) = smartWallet.call(data);
  }

  // Deploy a key ring and a smart wallet, then call the smart wallet
  // with arbitrary data.
  function deployKeyRingAndWalletAndCall(
    address initialSigningKey, // the initial key on the keyring
    address keyRing,
    address smartWallet,
    bytes calldata data
  ) external returns (bool ok, bytes memory returnData) {
    _deployNewKeyRingIfNeeded(initialSigningKey, keyRing);
    _deployNewSmartWalletIfNeeded(keyRing, smartWallet);
    (ok, returnData) = smartWallet.call(data);
  }
 
  // Get an actionID for the first action on a smart wallet before it
  // has been deployed.
  // no argument: empty string - abi.encode();
  // one argument, like setUserSigningKey: abi.encode(argument)
  // withdrawals: abi.encode(amount, recipient)
  // generics: abi.encode(to, data)
  // generic batch: abi.encode(calls) -> array of {address to, bytes data}
  function getInitialActionID(
    address smartWallet,
    address initialUserSigningKey, // the key ring
    DharmaSmartWalletInterface.ActionType actionType,
    uint256 minimumActionGas,
    bytes calldata arguments
  ) external view returns (bytes32 actionID) {
    actionID = keccak256(
      abi.encodePacked(
        smartWallet,
        _getVersion(),
        initialUserSigningKey,
        _KEY_REGISTRY.getKeyForUser(smartWallet),
        uint256(0), // nonce starts at 0
        minimumActionGas,
        actionType,
        arguments
      )
    );
  }
 
  function _deployNewKeyRingIfNeeded(
    address initialSigningKey, address expectedKeyRing
  ) internal returns (address keyRing) {
    // Only deploy if a smart wallet doesn't already exist at expected address.
    bytes32 hash;
    assembly { hash := extcodehash(expectedKeyRing) }
    if (hash != _KEY_RING_INSTANCE_RUNTIME_HASH) {
      require(
        _KEYRING_FACTORY.getNextKeyRing(initialSigningKey) == expectedKeyRing,
        "Key ring to be deployed does not match expected key ring."
      );
      keyRing = _KEYRING_FACTORY.newKeyRing(initialSigningKey, expectedKeyRing);
    } else {
      // Note: the key ring at the expected address may have been modified so that
      // the supplied user signing key is no longer a valid key - therefore, treat
      // this helper as a way to protect against race conditions, not as a primary
      // mechanism for interacting with key ring contracts.
      keyRing = expectedKeyRing;
    }
  } 
  
  function _deployNewSmartWalletIfNeeded(
    address userSigningKey, // the key ring
    address expectedSmartWallet
  ) internal returns (address smartWallet) {
    // Only deploy if a smart wallet doesn't already exist at expected address.
    bytes32 hash;
    assembly { hash := extcodehash(expectedSmartWallet) }
    if (hash != _SMART_WALLET_INSTANCE_RUNTIME_HASH) {
      require(
        _WALLET_FACTORY.getNextSmartWallet(userSigningKey) == expectedSmartWallet,
        "Smart wallet to be deployed does not match expected smart wallet."
      );
      smartWallet = _WALLET_FACTORY.newSmartWallet(userSigningKey);
    } else {
      // Note: the smart wallet at the expected address may have been modified
      // so that the supplied user signing key is no longer a valid key.
      // Therefore, treat this helper as a way to protect against race
      // conditions, not as a primary mechanism for interacting with smart
      // wallet contracts.
      smartWallet = expectedSmartWallet;
    }
  }

  function _getVersion() internal view returns (uint256 version) {
    (, bytes memory data) = beacon.staticcall("");
    address implementation = abi.decode(data, (address));
    version = DharmaSmartWalletInterface(implementation).getVersion();
  }
}