;; olive-css
;;
;; SPDX-License-Identifier: MIT
;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

(define-module (olive-css decl colors)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (ice-9 string-fun)
  #:use-module (olive-css dsl))

(define-public redwood-oklch
  '(0.5591 0.1288 31.7))

(define-public redwood
  (make-parameter (make-palette redwood-oklch)))

(define-public melon-oklch
  '(0.7664 0.0661 30.56))

(define-public melon
  (make-parameter (make-palette melon-oklch)))

(define-public charcoal-oklch
  '(0.3798 0.0343 266.95))

(define-public charcoal
  (make-parameter (make-palette charcoal-oklch)))

(define-public glaucous-oklch
  '(0.5653 0.0696 251.18))

(define-public glaucous
  (make-parameter (make-palette glaucous-oklch)))

(define-public cambridge-green-oklch
  '(0.6443 0.0467 168.05))

(define-public cambridge-green
  (make-parameter (make-palette cambridge-green-oklch)))

(define-public iris-oklch
  '(0.4929 0.161 279.98))

(define-public iris
  (make-parameter (make-palette iris-oklch)))

(define-public mantis-oklch
  '(0.7048 0.1321 144.02))

(define-public mantis
  (make-parameter (make-palette mantis-oklch)))

(define-public china-rose-oklch
  '(0.6023 0.1041 7.06))

(define-public china-rose
  (make-parameter (make-palette china-rose-oklch)))

(define-public china-violet-oklch
  '(0.5161 0.0609 310.77))

(define-public china-violet
  (make-parameter (make-palette china-violet-oklch)))

(define-public light-coral-oklch
  '(0.6751 0.152 20.02))

(define-public light-coral
  (make-parameter (make-palette light-coral-oklch)))

(define-public jeans-blue-oklch
  '(0.452 0.0712 256.28))

(define-public jeans-blue
  (make-parameter (make-palette jeans-blue-oklch)))

(define-public buff-oklch
  '(0.7871 0.0895 49.68))

(define-public buff
  (make-parameter (make-palette buff-oklch)))

(define-public tawny-oklch
  '(0.6183 0.1557 45.26))

(define-public tawny
  (make-parameter (make-palette tawny-oklch)))

(define-public moonstone-oklch
  '(0.6609 0.0708 213.97))

(define-public moonstone
  (make-parameter (make-palette moonstone-oklch)))

(define-public claret-oklch
  '(0.4111 0.1625 5.42))

(define-public claret
  (make-parameter (make-palette claret-oklch)))

(define-public castleton-green-oklch
  '(0.3771 0.0754 167.02))

(define-public castleton-green
  (make-parameter (make-palette castleton-green-oklch)))

(define-public lapis-lazuli-oklch
  '(0.4595 0.0968 251.94))

(define-public lapis-lazuli
  (make-parameter (make-palette lapis-lazuli-oklch)))

(define-public cadet-gray-oklch
  '(0.654 0.0185 225.33))

(define-public cadet-gray
  (make-parameter (make-palette cadet-gray-oklch)))

(define-public ash-gray-oklch
  '(0.8342 0.0248 196.69))

(define-public ash-gray
  (make-parameter (make-palette ash-gray-oklch)))

(define-public dark-purple-oklch
  '(0.3022 0.0506 0.51))

(define-public dark-purple
  (make-parameter (make-palette dark-purple-oklch)))

(define-public pomp-and-power-oklch
  '(0.5818 0.0719 310.07))

(define-public pomp-and-power
  (make-parameter (make-palette pomp-and-power-oklch)))

(define-public black-olive-oklch
  '(0.4087 0.0176 128.95))

(define-public black-olive
  (make-parameter (make-palette black-olive-oklch)))

(define-public white-smoke-oklch
  '(0.9702 0 0))

(define-public white-smoke
  (make-parameter (make-palette white-smoke-oklch)))

(define-public russia-violet-oklch
  '(0.3016 0.1166 317.88))

(define-public russia-violet
  (make-parameter (make-palette russia-violet-oklch)))

(define-public tyrian-oklch
  '(0.3409 0.1048 358.88))

(define-public tyrian
  (make-parameter (make-palette tyrian-oklch)))

(define-public persia-pink-oklch
  '(0.7404 0.1399 348.9))

(define-public persia-pink
  (make-parameter (make-palette persia-pink-oklch)))

(define-public naples-yellow-oklch
  '(0.9011 0.1449 97.97))

(define-public naples-yellow
  (make-parameter (make-palette naples-yellow-oklch)))

(define-public apple-green-oklch
  '(0.7214 0.1697 119.64))

(define-public apple-green
  (make-parameter (make-palette apple-green-oklch)))

(define-public mikado-yellow-oklch
  '(0.8538 0.1734 87.35))

(define-public mikado-yellow
  (make-parameter (make-palette mikado-yellow-oklch)))

(define-public bistre-oklch
  '(0.2732 0.0607 61.09))

(define-public bistre
  (make-parameter (make-palette bistre-oklch)))

(define-public black-bean-oklch
  '(0.2453 0.0769 40.07))

(define-public black-bean
  (make-parameter (make-palette black-bean-oklch)))

(define-public sienna-oklch
  '(0.4307 0.1478 35.91))

(define-public sienna
  (make-parameter (make-palette sienna-oklch)))

(define-public umber-oklch
  '(0.4106 0.0384 61.8))

(define-public umber
  (make-parameter (make-palette umber-oklch)))

(define-public beaver-oklch
  '(0.6651 0.0536 62.76))

(define-public beaver
  (make-parameter (make-palette beaver-oklch)))

(define-public coffee-oklch
  '(0.462 0.0615 63.5))

(define-public coffee
  (make-parameter (make-palette coffee-oklch)))

(define-public pale-dogwood-oklch
  '(0.8322 0.0512 42.95))

(define-public pale-dogwood
  (make-parameter (make-palette pale-dogwood-oklch)))

(define-public spiced-terracotta-oklch
  '(0.6277 0.1081 53.34))

(define-public spiced-terracotta
  (make-parameter (make-palette spiced-terracotta-oklch)))

(define-public orange-crayola-oklch
  '(0.7404 0.1444 57.26))

(define-public orange
  (make-parameter (make-palette orange-crayola-oklch)))

(define-public stone-oklch
  '(0.907 0.0013 286.37))

(define-public stone
  (make-parameter (make-palette stone-oklch
                                #:transformers (list (list 100 lighten-oklch
                                                           0.08)
                                                     (list 300 lighten-oklch
                                                           0.04)
                                                     (list 500 identity-oklch
                                                           0)
                                                     (list 700 darken-oklch
                                                           0.05)
                                                     (list 900 darken-oklch
                                                           0.1)))))

(define-public raisin-black-oklch
  '(0.2711 0.011 285.64))

(define-public raisin-black
  (make-parameter (make-palette raisin-black-oklch)))

(define-public asparagus-oklch
  '(0.6012 0.0882 137.17))

(define-public asparagus
  (make-parameter (make-palette asparagus-oklch)))

(define-public midnight-green-oklch
  '(0.4108 0.0614 214.25))

(define-public midnight-green
  (make-parameter (make-palette midnight-green-oklch)))

(define-public wine-oklch
  '(0.4284 0.0747 9.86))

(define-public wine
  (make-parameter (make-palette wine-oklch)))

(define-public van-dyke-oklch
  '(0.3297 0.0387 11.82))

(define-public van-dyke
  (make-parameter (make-palette van-dyke-oklch)))

(define-public prussian-blue-oklch
  '(0.3093 0.0627 254.14))

(define-public prussian-blue
  (make-parameter (make-palette prussian-blue-oklch)))

(define-public onyx-oklch
  '(0.3588 0.0044 247.95))

(define-public onyx
  (make-parameter (make-palette onyx-oklch)))

(define-public papaya-whip-oklch
  '(0.9622 0.0384 83.83))

(define-public papaya-whip
  (make-parameter (make-palette papaya-whip-oklch)))

(define-public floral-white-oklch
  '(0.9819 0.0164 91.55))

(define-public floral-white
  (make-parameter (make-palette floral-white-oklch)))

(define-public ferrari-red-oklch
  '(0.6399 0.2466 31.39))

(define-public ferrari-red
  (make-parameter (make-palette ferrari-red-oklch)))

(define-public olive-oklch
  '(0.7457 0.1007 128.08))

(define-public olive
  (make-parameter (make-palette olive-oklch)))

(define-public dark-khaki-oklch
  '(0.7675 0.098 104.51))

(define-public dark-khaki
  (make-parameter (make-palette dark-khaki-oklch)))

(define-public terra-oklch
  '(0.6528 0.1464 39.15))

(define-public terra
  (make-parameter (make-palette terra-oklch)))
