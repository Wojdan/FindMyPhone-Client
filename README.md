![FindMyPhone Logo](https://github.com/Wojdan/FindMyPhone-Client/blob/master/FindMyPhoneClient/FindMyPhoneClient/icon%402x.png)
# Opis aplikacji wraz z instrukcją dot. developmentu oraz kompilacji #

Instrukcja dotyczy dowolnego systemu z rodziny OS X od wersji Mavericks wzwyż.
Instrukcja została pomyślnie przetestowana na surowym systemie OS X 10.9.5

## Ogólnie o aplikacji ##

Jest to aplikacja kliencka systemu służącego do śledzenia telefonów o nazwie **FindMyPhone** przeznaczona na platformę [iOS](http://pl.wikipedia.org/wiki/IOS).

### [Demonstracja interfejsu](http://invis.io/461R1ESJY) / [Repozytorium](https://bitbucket.org/zpi16ios/client/)  ###
 
Aplikacja:

* powstała w języku [Objective-C](http://pl.wikipedia.org/wiki/Objective-C)
* jest przeznaczona na platformę [iOS](http://pl.wikipedia.org/wiki/IOS)
* powstała przy użyciu środowiska (IDE) [Xcode 6.1](http://pl.wikipedia.org/wiki/Xcode)
* wykorzystuje biblioteki [Cocoapods](http://guides.cocoapods.org/), głównie [AFNetworking](https://github.com/AFNetworking/AFNetworking) - do obsługi REST'owego API.

![iOS Logo](http://thexbmcguide.com/wp-content/uploads/2012/03/ios-logo.jpg)
![Xcode Logo](https://devimages.apple.com.edgekey.net/assets/elements/icons/128x128/xcode.png)
![AFNetworking Logo](https://lh3.googleusercontent.com/proxy/UbItKB_-DdOV5V4Y_Jlg_FRHw8qVM7t6QW3tGF2yHR7AJ8sJ4ZuP60676mRnJpFwJnZH2VdZkIJZgLi_Y84IjVEvkJwGf7kssyEj9dVaUa_NAP74Mn-xHrw=w120-h120)

## Wymagania przed rozpoczęciem pracy ##

Przed przystąpieniem do wdrażania instrukcji należy zainstalować:

* gem cocoapods
```
sudo gem install cocoapods
```

## Instalacja potrzebnych bibliotek ##

1. Wejdź do katalogu w którym znajduje się plik ```Podfile```
2. Wykonaj poniższy skrypt

```
#!
pod setup
pod install
```

## Kompilacja ##

Do uruchomienia aplikacji potrzebny będzie system z w/w rodziny systemów OSX z zainstalowanym środowiskiem Xcode i iOS SDK. Aby zbudować aplikację, należy otworzyć plik projektu, następnie z zakładki ```Projekt``` wybrać opcję ```Run```. Budowanie aplikacji na symulatorze skutkuje ograniczonymi możliwościami testowania ze względu na to, ze symulator nie jest wyposażony w prawdziwe serwisy lokalizacji, a jedynie je emuluje.
