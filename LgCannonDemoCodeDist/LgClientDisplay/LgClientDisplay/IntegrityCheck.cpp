#include "IntegrityCheck.h"

#include <windows.h>
#include <wincrypt.h>
#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include <vector>
#include <openssl/crypto.h>
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/bio.h>
#include <openssl/err.h>


#pragma comment(lib, "crypt32.lib")

bool VerifySignature(const std::string& publicKeyFile, const std::string& signatureFile, const std::string& dataFile) {
    EVP_PKEY* pubkey = nullptr;
    EVP_MD_CTX* mdctx = nullptr;


    OpenSSL_add_all_algorithms();
    ERR_load_crypto_strings();



    BIO* bioPub = BIO_new_file(publicKeyFile.c_str(), "r");
    if (!bioPub) {
        std::cout << "Failed to open public key file: " << publicKeyFile << std::endl;
        return false;
    }
    pubkey = PEM_read_bio_PUBKEY(bioPub, nullptr, nullptr, nullptr);
    BIO_free(bioPub);
    if (!pubkey) {
        std::cout << "Failed to read public key from file" << std::endl;
        return false;
    }



    std::ifstream signatureStream(signatureFile, std::ios::binary);
    if (!signatureStream) {
        std::cout << "Failed to open signature file: " << signatureFile << std::endl;
        EVP_PKEY_free(pubkey);
        return false;
    }
    std::vector<unsigned char> signature((std::istreambuf_iterator<char>(signatureStream)),
        std::istreambuf_iterator<char>());
    signatureStream.close();



    std::ifstream dataStream(dataFile, std::ios::binary);
    if (!dataStream) {
        std::cout << "Failed to open data file: " << dataFile << std::endl;
        EVP_PKEY_free(pubkey);
        return false;
    }
    std::vector<unsigned char> data((std::istreambuf_iterator<char>(dataStream)),
        std::istreambuf_iterator<char>());
    dataStream.close();


    mdctx = EVP_MD_CTX_new();
    if (!mdctx) {
        std::cout << "Failed to create EVP_MD_CTX" << std::endl;
        EVP_PKEY_free(pubkey);
        return false;
    }
    if (EVP_DigestVerifyInit(mdctx, nullptr, EVP_sha256(), nullptr, pubkey) != 1) {
        std::cout << "EVP_DigestVerifyInit failed" << std::endl;
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pubkey);
        return false;
    }
    if (EVP_DigestVerifyUpdate(mdctx, data.data(), data.size()) != 1) {
        std::cout << "EVP_DigestVerifyUpdate failed" << std::endl;
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(pubkey);
        return false;
    }


    int result = EVP_DigestVerifyFinal(mdctx, signature.data(), signature.size());
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pubkey);

    if (result == 1) {
        std::cout << "Signature verified successfully" << std::endl;
        return true;
    }
    else if (result == 0) {
        std::cout << "Signature verification failed" << std::endl;
        return false;
    }
    else {
        std::cout << "Error occurred during signature verification" << std::endl;
        return false;
    }
}

bool VerifyFileIntegrity() {
    const std::string certPath = "./openvpn/public_key.pem";

    const std::vector<std::pair<std::string, std::string>> files = {
        {"./openvpn/openvpn.exe", "./openvpn/openvpn.signature.bin"},
        {"./openvpn/libcrypto-3-x64.dll", "./openvpn/libcrypto-3-x64.signature.bin"},
        {"./openvpn/libopenvpn_plap.dll", "./openvpn/libopenvpn_plap.signature.bin"},
        {"./openvpn/libpkcs11-helper-1.dll", "./openvpn/libpkcs11-helper-1.signature.bin"},
        {"./openvpn/libssl-3-x64.dll", "./openvpn/libssl-3-x64.signature.bin"}
    };

    for (const auto& f : files) {
        if (!VerifySignature(certPath, f.second, f.first)) {
            std::cerr << "Failed to verify signature : " << f.first << std::endl;
            return false;
        }
    }
    return true;
}
