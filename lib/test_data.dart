import 'model/fabric.dart';
import 'model/order.dart';
import 'model/client.dart';
import 'model/report.dart';

List<Client> testClients = [
  Client(
    name: '',
    surname: 'Колумб',
    middleName: '',
    city: 'Генуя',
    address: 'ул. Красная, д.137, кв. 381',
    volume: '',
    previousDate: '12.02.1466',
    nextDate: '',
    //'images':'',
  ),
  Client(
    name: 'Исаак',
    surname: 'Ньютон',
    middleName: '',
    city: 'Вулсторп',
    address: '',
    volume: '20',
    previousDate: '24.09.1689',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Луи',
    surname: 'Пастер',
    middleName: '',
    city: 'Доль',
    address: '',
    volume: '',
    previousDate: '',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Джеймс',
    surname: 'Максвелл',
    middleName: 'Клерк',
    city: 'Эдинбург',
    address: '',
    volume: '10',
    previousDate: '07.03.1844',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Джон',
    surname: 'Дальтон',
    middleName: '',
    city: 'Иглсфилд',
    address: '',
    volume: '13',
    previousDate: '',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: '',
    surname: 'Колумб',
    middleName: '',
    city: 'Генуя',
    address: 'ул. Красная, д.137, кв. 381',
    volume: '',
    previousDate: '12.02.1466',
    nextDate: '',
    //'images':'',
  ),
  Client(
    name: 'Исаак',
    surname: 'Ньютон',
    middleName: '',
    city: 'Вулсторп',
    address: '',
    volume: '20',
    previousDate: '24.09.1689',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Луи',
    surname: 'Пастер',
    middleName: '',
    city: 'Доль',
    address: '',
    volume: '',
    previousDate: '',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Джеймс',
    surname: 'Максвелл',
    middleName: 'Клерк',
    city: 'Эдинбург',
    address: '',
    volume: '10',
    previousDate: '07.03.1844',
    nextDate: '',
    //images:'',
  ),
  Client(
    name: 'Джон',
    surname: 'Дальтон',
    middleName: '',
    city: 'Иглсфилд',
    address: '',
    volume: '13',
    previousDate: '',
    nextDate: '',
    //images:'',
  ),
];

List<Order> testOrders = [
  Order(
    client: testClients[0],
    date: '21.02.12',
    done: false,
    price: 1000,
    expenses: 250,
    comment:
        'dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasda  dsadasdsadasda dsadasdsadasdadsadasdsadasda dsadasdsadasdav',
  ),
  Order(
    client: testClients[1],
    date: '21.07.05',
    done: false,
    price: 4300,
    expenses: 260,
    comment:
        'dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasda  dsadasdsadasda dsadasdsadasdadsadasdsadasda dsadasdsadasdav',
  ),
  Order(
    client: testClients[2],
    date: '12.02.05',
    done: false,
    price: 10320,
    expenses: 450.5,
    comment:
        'dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasda  dsadasdsadasda dsadasdsadasdadsadasdsadasda dsadasdsadasdav',
  ),
  Order(
    client: testClients[3],
    date: '21.09.17',
    done: false,
    price: 4300,
    expenses: 260,
  ),
  Order(
    client: testClients[0],
    date: '21.02.12',
    done: false,
    price: 101.35,
    expenses: 250,
    comment:
        'dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasda  dsadasdsadasda dsadasdsadasdadsadasdsadasda dsadasdsadasdav',
  ),
  Order(
    client: testClients[0],
    date: '21.02.12',
    done: false,
    price: 32100,
    expenses: 4550,
  ),
  Order(
    client: testClients[1],
    date: '21.07.05',
    done: false,
    price: 4300,
    expenses: 260,
  ),
  Order(
    client: testClients[2],
    date: '21.02.12',
    done: false,
    price: 1040,
    expenses: 57,
    comment:
        'dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasda dsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasdadsadasdsadasda  dsadasdsadasda dsadasdsadasdadsadasdsadasda dsadasdsadasdav',
  ),
  Order(
    client: testClients[3],
    date: '21.09.17',
    done: false,
    price: 4300,
    expenses: 260,
  ),
  Order(
    client: testClients[0],
    date: '21.02.12',
    done: false,
    price: 4300,
    expenses: 260,
  ),
];

List<Fabric> testFabrics = [
  Fabric(
    title: 'Дерево',
    retailPrice: 25,
    purchasePrice: 12,
  ),
  Fabric(
    title: 'Металл',
    retailPrice: 124,
    purchasePrice: 52,
  ),
  Fabric(
    title: 'Стекло',
    retailPrice: 12,
    purchasePrice: 5,
  ),
  Fabric(
    title: 'Пластмасса',
    retailPrice: 26,
    purchasePrice: 15,
  ),
  Fabric(title: 'Бетон'),
  Fabric(title: 'Камень'),
  Fabric(title: 'Гипсокартон'),
];

List<Report> testReports = [
  Report(
    timePeriod: 'Февраль',
    profit: 13542,
    date: '20210225',
  ),
  Report(
    timePeriod: 'Март',
    profit: 15512.1,
    date: '20210325',
  ),
  Report(
    timePeriod: 'Январь',
    profit: 17620.5,
    date: '20210125',
  ),
  Report(
    timePeriod: '2020 год',
    profit: 82135,
    date: '20210101',
  ),
];
