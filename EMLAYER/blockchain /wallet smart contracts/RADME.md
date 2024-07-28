Gayrimenkul Sektörü Cüzdan Uygulaması Akıllı Sözleşmeleri

Bu proje, gayrimenkul sektöründe gelir ve giderleri blockchain teknolojisiyle kolaylıkla takip edebilmeleri için akıllı sözleşmeler içeren bir cüzdan uygulaması sunmaktadır. Akıllı sözleşmeler, ödemeleri yönetmek, gelir ve giderleri takip etmek, yatırımcılarla etkileşim kurmak ve mülk sigortası gibi işlemleri otomatikleştirmek amacıyla tasarlanmıştır.

İçindekiler

	1.	Ödeme İşlemleri (Payment Processor)
	2.	Gelir ve Gider Takibi (Financial Tracker)
	3.	Otomatik Kira Ödemeleri ve Cezalar (Rent Payment)
	4.	Mülk Yatırımcıları ve Paylaşım (Revenue Sharing)
	5.	Sigorta İşlemleri (Insurance Management)
	6.	Bakım ve Onarım İşleri (Maintenance and Repairs)

Ödeme İşlemleri (Payment Processor)

Açıklama

PaymentProcessor sözleşmesi, kira, satış, bakım ve diğer ödemeleri yönetir. Kiracılar, mülk sahipleri ve yöneticiler arasındaki ödeme işlemlerini otomatikleştirir.

İşlevler

	•	payRent(): Kira ödemelerini alır.
	•	makeSalePayment(): Satış ödemelerini gerçekleştirir.
	•	payForMaintenance(): Bakım ödemelerini yapar.

Kullanım

	1.	Sözleşmeyi başlatın ve mülk yöneticisini belirleyin.
	2.	Kiracılar payRent() işlevini kullanarak kira ödemelerini yapabilir.
	3.	Mülk sahipleri makeSalePayment() işlevi ile satış ödemelerini alabilir.
	4.	Yöneticiler payForMaintenance() işlevini kullanarak bakım ödemelerini gerçekleştirebilir.

Gelir ve Gider Takibi (Financial Tracker)

Açıklama

FinancialTracker sözleşmesi, mülk sahiplerinin ve yöneticilerinin gelir ve giderlerini blockchain üzerinde takip etmelerini sağlar.

İşlevler

	•	recordIncome(uint256 _amount, string memory _description): Gelir kaydı ekler.
	•	recordExpense(uint256 _amount, string memory _description): Gider kaydı ekler.
	•	getIncomes(): Tüm gelir kayıtlarını alır.
	•	getExpenses(): Tüm gider kayıtlarını alır.

Kullanım

	1.	Yönetici, recordIncome() ve recordExpense() işlevleri ile gelir ve giderleri kaydeder.
	2.	getIncomes() ve getExpenses() işlevleri ile kayıtları görüntüler.

Otomatik Kira Ödemeleri ve Cezalar (Rent Payment)

Açıklama

RentPayment sözleşmesi, kira ödemelerini otomatik olarak alır ve geç ödeme durumunda cezalar uygular.

İşlevler

	•	payRent(): Kira ödemesini alır.
	•	payLateFee(): Gecikme cezasını alır.

Kullanım

	1.	Kiracılar payRent() işlevini kullanarak kira ödemelerini yapar.
	2.	Ödeme süresi geçtikten sonra, kiracılar payLateFee() işlevini kullanarak geç ödeme cezasını öder.

Mülk Yatırımcıları ve Paylaşım (Revenue Sharing)

Açıklama

RevenueSharing sözleşmesi, mülk gelirlerini yatırımcılara paylaştırır ve paylaşım oranlarını yönetir.

İşlevler

	•	addInvestor(address _investor, uint256 _share): Yatırımcı ekler ve paylaşım oranını belirler.
	•	distributeRevenue(): Gelirleri yatırımcılara dağıtır.

Kullanım

	1.	Yönetici, addInvestor() işlevi ile yatırımcıları ekler ve paylaşım oranlarını belirler.
	2.	distributeRevenue() işlevi ile gelirleri yatırımcılara paylaştırır.

Sigorta İşlemleri (Insurance Management)

Açıklama

InsuranceManagement sözleşmesi, mülk sigortası işlemlerini yönetir, sigorta primlerini öder ve sigorta taleplerini işler.

İşlevler

	•	payPremium(): Sigorta primini öder.
	•	fileClaim(): Sigorta talebini işler.

Kullanım

	1.	Mülk sahibi, payPremium() işlevini kullanarak sigorta primlerini öder.
	2.	Sigorta talepleri için fileClaim() işlevini kullanarak talepler oluşturur.

Bakım ve Onarım İşleri (Maintenance and Repairs)

Açıklama

MaintenanceAndRepairs sözleşmesi, mülklerde yapılan bakım ve onarımlar için ödemeleri yönetir ve işleri takip eder.

İşlevler

	•	recordMaintenance(uint256 _amount, string memory _description): Bakım ve onarım işlemini kaydeder.
	•	payForMaintenance(uint256 _amount): Bakım ödemelerini yapar.

Kullanım

	1.	Yöneticiler, recordMaintenance() işlevi ile bakım ve onarım işlemlerini kaydeder.
	2.	payForMaintenance() işlevi ile ödemeleri gerçekleştirir.