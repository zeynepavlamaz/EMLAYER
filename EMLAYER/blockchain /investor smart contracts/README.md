Yatırımcı Akıllı Sözleşmeleri

Bu repo, yatırımcılar için çeşitli akıllı sözleşmeleri içerir. Bu sözleşmeler, yatırım süreçlerini otomatikleştirmek ve şeffaf hale getirmek amacıyla tasarlanmıştır. Aşağıda, mevcut sözleşmelerin listesi ve açıklamaları yer almaktadır.

İçindekiler

	1.	Yatırım Anlaşması (Investment Agreement)
	2.	Yatırımcı Kâr Paylaşımı (Profit Sharing)
	3.	Yatırımcı Kimlik Doğrulama (Investor Verification)
	4.	Yatırımcı Yönetimi (Investor Management)

Yatırım Anlaşması (Investment Agreement)

Açıklama

InvestmentAgreement sözleşmesi, bir yatırımcının belirli bir miktarda yatırım yapmasını ve bu yatırımın belirlenen süre sonunda geri ödenmesini sağlar. Bu sözleşme, yatırım süresi dolduğunda geri ödeme işlemini otomatikleştirir.

İşlevler

	•	fundInvestment(): Yatırım miktarını yatırır ve yatırımı fonlar.
	•	repayInvestment(): Yatırım süresi dolduğunda yatırımcıya geri ödeme yapar.
	•	terminateContract(): Sözleşmeyi sonlandırır.

Kullanım

	1.	Yatırım anlaşmasını başlatın.
	2.	Yatırımcı, fundInvestment() işlevi ile yatırım yapar.
	3.	Yatırım süresi dolduğunda, repayInvestment() işlevini kullanarak geri ödeme yapın.
	4.	Sözleşme tamamlandığında, terminateContract() işlevi ile sözleşmeyi sonlandırın.

Yatırımcı Kâr Paylaşımı (Profit Sharing)

Açıklama

ProfitSharing sözleşmesi, yatırımcılara şirketin kârından belirli bir oranda pay verir. Bu sözleşme, kârın yatırımcılara adil bir şekilde dağıtılmasını sağlar.

İşlevler

	•	addInvestor(address _investor, uint256 _share): Yeni bir yatırımcı ekler ve kâr payı oranını belirler.
	•	distributeProfit(): Toplam kârı yatırımcılara dağıtır.
	•	receive(): Sözleşmeye Ether alır ve toplam kârı günceller.

Kullanım

	1.	Şirket, yatırımcıları addInvestor() işlevi ile ekler.
	2.	Kâr elde edildikçe, receive() işlevini kullanarak kârı sözleşmeye yatırın.
	3.	distributeProfit() işlevi ile kârı yatırımcılara dağıtın.

Yatırımcı Kimlik Doğrulama (Investor Verification)

Açıklama

InvestorVerification sözleşmesi, yatırımcıların kimliklerini doğrular ve doğrulama durumlarını yönetir. Bu sözleşme, yatırımcıların güvenliğini sağlamak için kullanılır.

İşlevler

	•	verifyInvestor(address _investor): Bir yatırımcıyı doğrular.
	•	revokeVerification(address _investor): Bir yatırımcının doğrulamasını iptal eder.
	•	isVerified(address _investor): Bir yatırımcının doğrulanmış olup olmadığını kontrol eder.

Kullanım

	1.	Yönetici, verifyInvestor() işlevi ile yatırımcıları doğrular.
	2.	revokeVerification() işlevi ile doğrulamayı iptal eder.
	3.	isVerified() işlevi ile bir yatırımcının doğrulama durumunu kontrol eder.

Yatırımcı Yönetimi (Investor Management)

Açıklama

InvestorManagement sözleşmesi, yatırımcı bilgilerini yönetir. Yatırımcı ekleyebilir, çıkarabilir ve bilgi güncelleyebilirsiniz.

İşlevler

	•	addInvestor(address _investor, string memory _name, uint256 _investmentAmount): Yeni bir yatırımcı ekler.
	•	removeInvestor(address _investor): Bir yatırımcıyı çıkarır.
	•	updateInvestmentAmount(address _investor, uint256 _investmentAmount): Yatırımcının yatırım miktarını günceller.
	•	getInvestorInfo(address _investor): Bir yatırımcının bilgilerini alır.

Kullanım

	1.	Yönetici, addInvestor() işlevi ile yatırımcıları ekler.
	2.	removeInvestor() işlevi ile yatırımcıları çıkarır.
	3.	updateInvestmentAmount() işlevi ile yatırımcı bilgilerini günceller.
	4.	getInvestorInfo() işlevi ile yatırımcı bilgilerini alır.
