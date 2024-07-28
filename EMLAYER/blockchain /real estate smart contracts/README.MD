Emlak Yönetimi Akıllı Sözleşmeleri

Bu projede, emlak yönetimi süreçlerini daha verimli ve güvenli hale getirmek için kullanılan akıllı sözleşmeleri bulacaksınız. Akıllı sözleşmeler, Ethereum blockchain’inde çalışarak işlemleri otomatikleştirir ve güvenliği artırır. Aşağıda, desteklenen işlevler ve sözleşmelerin ayrıntıları bulunmaktadır.

1. Kira Sözleşmeleri

Kira Sözleşmeleri kira ödemelerini, depozito yönetimini ve sözleşme şartlarının otomatik olarak yerine getirilmesini sağlar. Özellikler:

	•	Kira Ödemeleri: Kiracı, belirlenen kira bedelini ödemek zorundadır. Ödeme yapıldığında, kira bedeli mülk sahibine otomatik olarak transfer edilir.
	•	Depozito Yönetimi: Kiracıdan alınan depozito, kiralama süresi sonunda geri ödenir veya sözleşme şartlarına göre tutulabilir.
	•	Cezalar ve Sözleşme Yenileme: Kiracı ödeme yapmadığında otomatik olarak cezalar uygulanabilir. Ayrıca, sözleşme süresi dolduğunda otomatik yenileme yapılabilir.

Örnek Sözleşme: RentalAgreement.sol

2. Satış Sözleşmeleri

Satış Sözleşmeleri, emlak satışlarında alıcı ve satıcı arasında anlaşmanın sağlanmasını ve ödeme yapıldığında mülkün devrini otomatik olarak gerçekleştirir. Özellikler:

	•	Mülk Transferi: Satış işlemi tamamlandığında, mülkün devri otomatik olarak gerçekleştirilir.
	•	Ödeme Yönetimi: Ödeme alındığında, ilgili tüm işlemler otomatik olarak tamamlanır.

Örnek Sözleşme: SaleAgreement.sol

3. Komisyon Paylaşımı

Komisyon Paylaşımı sözleşmeleri, emlakçıların anlaşmaların veya satışların komisyonlarını belirler ve otomatik olarak hesaplar. Özellikler:

	•	Komisyon Hesaplama: Emlakçıların komisyonları, satış fiyatına göre otomatik olarak hesaplanır.
	•	Şeffaflık: Komisyon hesaplamaları ve ödemeleri şeffaf bir şekilde gerçekleştirilir.

Örnek Sözleşme: CommissionSharing.sol

4. Bakım ve Onarım İşleri

Bakım ve Onarım İşleri sözleşmeleri, kiralanan veya satılan mülklerdeki bakım ve onarımlar için kullanılır. Özellikler:

	•	Bakım Talebi: Mülk yöneticisi bakım talebinde bulunabilir.
	•	Ödeme Yönetimi: Bakım işleri tamamlandığında, bakım ücreti otomatik olarak ödenir.

Örnek Sözleşme: MaintenanceManagement.sol

5. İşlem Güvenliği

İşlem Güvenliği sözleşmeleri, mülk alım-satımında tüm tarafların kimlik doğrulama ve güvenlik adımlarını yönetir. Özellikler:

	•	Kimlik Doğrulama: Satıcı, alıcı ve üçüncü taraf güvence sağlayıcıların kimlikleri doğrulanır.
	•	Dolandırıcılık Riskini Azaltma: Güvenlik adımları ile dolandırıcılık riski azaltılır.

Örnek Sözleşme: TransactionSecurity.sol

6. Sigorta İşlemleri

Sigorta İşlemleri sözleşmeleri, mülk sigortası ile ilgili süreçlerin otomatikleştirilmesini sağlar. Özellikler:

	•	Sigorta Primleri: Sigorta primleri otomatik olarak ödenir.
	•	Sigorta Talepleri: Sigorta talepleri ve ödemeleri akıllı sözleşmeler aracılığıyla yönetilir.

Örnek Sözleşme: InsuranceManagement.sol

7. Emlak Yönetimi

Emlak Yönetimi sözleşmeleri, mülkün yönetimi ve kiralanması ile ilgili görevlerin otomatikleştirilmesini sağlar. Özellikler:

	•	Kira Bedeli Ödemeleri: Kira bedeli ödemeleri otomatik olarak gerçekleştirilir.
	•	Mülk Bakımı: Mülk bakımı ve ilgili işlemler otomatik olarak yönetilir.

Örnek Sözleşme: PropertyManagement.sol

Kullanım

Her bir sözleşme, belirli işlevleri yerine getirmek için tasarlanmıştır ve Ethereum blockchain’inde çalışır. Sözleşmelerin nasıl kullanılacağını öğrenmek için, her bir sözleşmenin ilgili Solidity koduna bakabilirsiniz.

Kurulum ve Dağıtım

	1.	Solidity Compiler: Sözleşmeleri derlemek için Solidity compiler kullanın.
	2.	Ethereum Wallet: Sözleşmeleri dağıtmak için bir Ethereum cüzdanı kullanın.
	3.	Deployment: Sözleşmeleri Ethereum ağına dağıtın ve gerekli parametreleri girin.

Lisans